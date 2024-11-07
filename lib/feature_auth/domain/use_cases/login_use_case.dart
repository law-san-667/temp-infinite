import 'package:infiniteagent/feature_auth/data/repositories/authentication_repository_impl.dart';

import '../../../config/services/services.dart';
import '../../../core/resources/user_entity.dart';

class LoginUseCase {
  final AuthRepositoryImpl _repository;

  LoginUseCase(this._repository);
  Future<void> call(String login, String password) async {
    try {
      UserEntity loggedUser = await _repository.login(login, password);
      if (loggedUser.authorities!.contains("ROLE_USER")) {
        _repository.logout();
        throw "Identifiants incorrects";
      }
      UserEntity.currentUser = loggedUser;
    } catch (error) {
      Services.debugLog("Error in login use case: $error");
      rethrow;
    }
  }
}

import 'package:infiniteagent/core/resources/user_entity.dart';

import '../../../config/services/services.dart';
import '../repositories/authentication_repository.dart';

class CheckIfLoggedUseCase {
  final AuthRepository _authRepository;

  CheckIfLoggedUseCase(this._authRepository);

  Future<bool> call() async {
    UserEntity? user =
        await _authRepository.checkLoggedUser().catchError((error) {
      Services.debugLog("Error in checkLoggedUser: $error");
      return null;
    });
    return user != null;
  }
}

import '../../config/services/services.dart';
import '../../feature_auth/domain/repositories/authentication_repository.dart';
import '../resources/user_entity.dart';

class LogoutUseCase {
  final AuthRepository _authenticationRepository;

  LogoutUseCase(this._authenticationRepository);

  Future call() async {
    await _authenticationRepository
        .logout()
        .then((_) => UserEntity.currentUser = null)
        .catchError((error) {
      Services.debugLog("Error in logout use case: $error");
      throw error;
    });
  }
}

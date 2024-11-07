import '../../../core/resources/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> checkLoggedUser();
  Future<void> login(String login, String password);
  // Future<DataState<User>> register(String email, String password);
  Future<void> logout();
}

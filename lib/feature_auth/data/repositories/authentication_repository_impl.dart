import 'package:infiniteagent/core/resources/user_entity.dart';
import 'package:infiniteagent/feature_auth/data/data_sources/local/authentication_local_data_source.dart';
import 'package:infiniteagent/feature_auth/domain/repositories/authentication_repository.dart';

import '../../../config/services/services.dart';
import '../data_sources/remote/authentication_remote_data_source.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource? _localDataSource;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<UserEntity?> checkLoggedUser() async {
    try {
      final token = await _localDataSource!.getToken();
      if (token == null) throw "No token found";
      Services.debugLog("Headers is: ${Services.header}");
      Services.header.putIfAbsent('Authorization', () => token);
      UserEntity? user =
          await _remoteDataSource.getLoggedUserInfo().catchError((error) async {
        Services.debugLog("Error in checkLoggedUser: $error");
        return await _localDataSource!.getUser();
      });
      if (user == null) throw "No user found";
      _localDataSource!.cacheUser(user);
      return user;
    } catch (error) {
      Services.debugLog("Error in checkLoggedUser: $error");
      rethrow;
    }
  }

  @override
  Future<UserEntity> login(String login, String password) async {
    try {
      final idToken = await _remoteDataSource.login(login, password);

      await _localDataSource!.cacheToken(idToken);
      Services.header.putIfAbsent('Authorization', () => idToken);
      final user = await _remoteDataSource.getLoggedUserInfo();
      if (user == null) throw "No user found";
      await _localDataSource!.cacheUser(user);
      if (user.authorities!.contains("ROLE_USER")) {
        logout();
        throw "Accès refusé";
      }
      return user;
    } catch (error) {
      Services.debugLog("Error in loginUser: $error");
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _localDataSource!.clearUserInfo();
      Services.header.remove('Authorization');
    } catch (error) {
      Services.debugLog("Error in logoutUser: $error");
      rethrow;
    }
  }
}

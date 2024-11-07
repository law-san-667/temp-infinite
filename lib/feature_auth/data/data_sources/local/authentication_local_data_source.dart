import 'dart:convert';

import 'package:infiniteagent/core/resources/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  final SharedPreferences _sharedPreferences;

  AuthLocalDataSource(this._sharedPreferences);

  Future<void> cacheToken(String token) async {
    await _sharedPreferences.setString('token', token);
  }

  Future cacheUser(UserEntity user) async {
    await _sharedPreferences.setString('user', jsonEncode(user.toJson()));
  }

  Future<void> clear() async {
    await _sharedPreferences.clear();
  }

  Future clearUserInfo() async {
    await _sharedPreferences.remove('user');
    await _sharedPreferences.remove('token');
  }

  Future<String?> getToken() async {
    return _sharedPreferences.getString('token');
  }

  Future<UserEntity?> getUser() async {
    final user = _sharedPreferences.getString('user');
    if (user != null) {
      return UserEntity.fromJson(jsonDecode(user));
    } else {
      return null;
    }
  }
}

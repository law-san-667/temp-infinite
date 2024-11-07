import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:infiniteagent/config/constants.dart';

import '../../../../config/services/services.dart';
import '../../../../core/resources/user_entity.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource();

  // Future<DataState<void>> changePassword(String oldPassword, String newPassword) async {
  //   // POST /account/change-password
  //   return await http
  //       .post(
  //           Uri.parse(
  //               '$api/account/change-password'),
  //           headers: Services.header,
  //           body: jsonEncode({
  //             'currentPassword': oldPassword,
  //             'newPassword': newPassword,
  //           }))
  //       .timeout(Duration(seconds: 5), onTimeout: () {
  //     throw "Connection au serveur impossible";
  //   }).then((res) {
  //     if (res.statusCode == 200) {
  //       Services.debugLog("Header was: ${Services.header}");
  //       Services.debugLog("Password changed successfully");
  //     } else {
  //       Services.debugLog(
  //           "Error in changePassword request body => ${res.body}");
  //       throw Services.translateError(jsonDecode(res.body)['title']);
  //     }
  //   }).catchError((error) {
  //     if (error is SocketException || error is http.ClientException) {
  //       throw "Internet connection failed";
  //     }
  //     Services.debugLog("Error in changePassword request : $error");
  //     throw error;
  //   });
  // }

  // Future<UserEntity> checkUserByLogin(String login) async {
  //   try {
  //     final res = await http
  //         .get(
  //             Uri.parse(
  //                 '$api/users/verify/client/$login'),
  //             headers: Services.header)
  //         .timeout(const Duration(seconds: 5), onTimeout: () {
  //       throw "Connection au serveur impossible";
  //     });
  //     if (res.statusCode == 200) {
  //       // Services.debugLog("response : ${res.body}");
  //       return UserEntity.fromJson(jsonDecode(res.body));
  //     } else {
  //       Services.debugLog("Can't get user by login");
  //       throw "User not found";
  //     }
  //   } catch (e) {
  //     if (e is SocketException || e is http.ClientException) {
  //       throw "Internet connection failed";
  //     }

  //     Services.debugLog(
  //         '$api/users/verify/client/$login');
  //     Services.debugLog("Error in checkUserByLogin request: $e");
  //     rethrow;
  //   }
  // }

  Future<UserEntity?> getLoggedUserInfo() async {
    try {
      final res = await http
          .get(Uri.parse('$api/account'), headers: Services.header)
          .timeout(const Duration(seconds: 5), onTimeout: () {
        throw "Connection au serveur impossible";
      });
      if (res.statusCode == 200) {
        try {
          UserEntity user = UserEntity.fromJson(jsonDecode(res.body));
          Services.debugLog("User info fetched successfully: ${user.toJson()}");
          return user;
        } catch (e) {
          Services.debugLog("Error => $e");
          throw "Une erreur est survenue...";
        }
      } else {
        Services.debugLog(
            "Error in getLoggedUserInfo : ${jsonDecode(res.body)}");
        throw "Request error";
      }
    } catch (error) {
      Services.debugLog("Error in getLoggedUserInfo : $error");
      if (error is SocketException || error is http.ClientException) {
        throw "Internet connection failed";
      }
      rethrow;
    }
  }

  Future<String> login(String id, String password) async {
    try {
      // Services.debugLog("login request header => ${Services.header}");
      final res = await http
          .post(Uri.parse('$api/authenticate'),
              headers: Services.header,
              body: jsonEncode({
                'username': id,
                'password': password,
              }))
          .timeout(const Duration(seconds: 5), onTimeout: () {
        throw "Connection au serveur impossible";
      });

      final resultBody = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final token = jsonDecode(res.body)['id_token'];
        return 'Bearer $token';
      } else {
        Services.debugLog("Error in login request body => ${res.body}");
        Services.debugLog("{'username': $id,'password': $password,}");
        if (res.statusCode == 401) {
          if (resultBody['detail'].toString().contains("activated")) {
            throw "Votre compte n'est pas activé";
          }
          throw "Identifiants incorrects";
        }
        throw "Connexion impossible, veuillez réessayer";
      }
    } catch (error) {
      Services.debugLog("error in login request : $error");
      if (error is SocketException || error is http.ClientException) {
        throw "Internet connection failed";
      }
      rethrow;
    }
  }

  // Future<bool> register(String firstname, String lastname, String phone,
  //     String email, String password) async {
  //   final res = await http
  //       .post(Uri.parse('$api/register/client'),
  //           headers: Services.header,
  //           body: jsonEncode({
  //             'firstName': firstname.trim(),
  //             'lastName': lastname.trim(),
  //             'login': phone.trim(),
  //             'password': password.trim(),
  //             'email': email.trim()
  //           }))
  //       .timeout(Duration(seconds: 5), onTimeout: () {
  //     throw "Connection au serveur impossible";
  //   });
  //   if (res.statusCode == 201) {
  //     return true;
  //   } else {
  //     Services.debugLog("Error in register request body => ${res.body}");
  //     throw Services.translateError(jsonDecode(res.body)['title']);
  //   }
  // }

  // Future<void> resetPasswordRequest(String email) async {
  //   try {
  //     final res = await http
  //         .post(
  //       Uri.parse("$api/account/reset-password/login/mail/init"),
  //       headers: Services.header,
  //       body: email,
  //     )
  //         .timeout(const Duration(seconds: 5), onTimeout: () {
  //       throw "Connection au serveur impossible";
  //     });
  //     if (res.statusCode == 200) {
  //       // Services.debugLog("Firebase token updated !");
  //     } else {
  //       Services.debugLog("Can't update firebase token ! : ${res.body}");
  //       throw "Can't update firebase token !";
  //     }
  //   } catch (e) {
  //     if (e is SocketException || e is http.ClientException) {
  //       throw "Internet connection failed";
  //     }

  //     Services.debugLog("Error in updateFirebaseToken request: $e");
  //     rethrow;
  //   }
  // }

  // Future<void> updateFirebaseToken(String token) {
  //   //PutMapping("/user-informations/firebase
  //   try {
  //     return http
  //         .put(
  //       Uri.parse("$api/user-informations/firebase"),
  //       headers: Services.header,
  //       body: token,
  //     )
  //         .timeout(const Duration(seconds: 5), onTimeout: () {
  //       throw "Connection au serveur impossible";
  //     }).then((value) {
  //       if (value.statusCode == 200) {
  //       } else {
  //         Services.debugLog("Can't update firebase token ! : ${value.body}");
  //         throw "Can't update firebase token !";
  //       }
  //     });
  //   } catch (e) {
  //     if (e is SocketException || e is http.ClientException) {
  //       throw "Internet connection failed";
  //     }

  //     Services.debugLog("Error in updateFirebaseToken request: $e");
  //     rethrow;
  //   }
  // }
}

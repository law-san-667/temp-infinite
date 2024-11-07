import 'package:geolocator/geolocator.dart';

class UserEntity {
  static UserEntity? currentUser;
  static Position? currentPosition;
  static String? token,
      privKey,
      pubKey,
      locality,
      searchArgs,
      phone; //To be deleted
  final String? localityCode;
  final String firstname, lastname, email, login;
  final int? id;
  final List? authorities;

  UserEntity({
    this.id,
    this.authorities,
    this.localityCode,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.login,
  });

  //FromJson
  factory UserEntity.fromJson(Map<String, dynamic> json) {
    // Services.debugLog("UserEntity.fromJson: $json");
    return UserEntity(
      id: json['id'],
      authorities: json['authorities'],
      localityCode: json['localityCode'],
      email: json['email'],
      firstname: json['firstName'],
      lastname: json['lastName'],
      login: json['login'],
    );
  }
  String get fullName => "$firstname $lastname";

  //ToJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorities': authorities,
      'localityCode': localityCode,
      'email': email,
      'firstName': firstname,
      'lastName': lastname,
      'login': login,
    };
  }
}

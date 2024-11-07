import 'package:azlistview/azlistview.dart';
import 'package:infiniteagent/core/resources/polygon_entity.dart';

import '../../../config/services/services.dart';

//Information obligatoire Nom, Prénom, Lat, Lon, Polygone, Télephone (login
class CensusEntity extends ISuspensionBean {
  final String firstName;
  final String lastName;
  final String phone;
  final num lat;
  final num lon;
  final String address;
  String? whatsapp;
  PolygonEntity field;
  String? id;

  CensusEntity({
    this.id,
    this.whatsapp,
    required this.firstName,
    required this.lastName,
    required this.lat,
    required this.lon,
    required this.phone,
    required this.address,
    required this.field,
  });

  CensusEntity.empty()
      : id = '',
        firstName = '',
        lastName = '',
        phone = '',
        lat = 0,
        lon = 0,
        address = '',
        field = PolygonEntity.empty();

  //FromJson
  factory CensusEntity.fromJson(Map<String, dynamic> json) {
    try {
      return CensusEntity(
        id: json['id'],
        firstName: json['ownerFirstName'],
        lastName: json['ownerLastName'],
        lat: json['lat'],
        lon: json['lon'],
        phone: json['ownerPhone'],
        address: json['region'],
        // field: PolygonEntity.getMockedList().first,
        field: json['polygon'] != null
            ? PolygonEntity.fromJson(json['polygon'])
            : PolygonEntity.empty(),
      );
    } catch (e) {
      Services.debugLog("Error in CensusEntity.fromJson : $e");
      return CensusEntity.empty();
    }
  }
  String get fullName => "$firstName $lastName";

  String get userInitials =>
      "https://api.dicebear.com/9.x/initials/png?seed=$fullName";

  @override
  String getSuspensionTag() => fullName;

  bool isBottomOfList(Map<String, List<CensusEntity>> groupedMap) {
    return groupedMap[fullName[0].toUpperCase()]?.last == this;
  }

  bool isTopOfList(Map<String, List<CensusEntity>> groupedMap) {
    return groupedMap[fullName[0].toUpperCase()]?.first == this;
  }

  //toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': 'SOLAR_INSTALLATION',
      'polygon': field.coordinates.length > 0 ? field.toJson() : null,
      'lat': lat,
      'lon': lon,
      "category": "agriculture",
      "numberOfPersonOnTheField": 0,
      "groundWaterLevel": 0,
      "distanceMainRoad": 0,
      "distanceTelecomInstallation": 0,
      "ph": 0, // PH
      "area": 0, // Superficie
      'coverImage': userInitials,
      // p,
      'ownerFirstName': firstName,
      'ownerLastName': lastName,
      'ownerPhone': phone,
      'ownerWhatsApp': phone,
      'region': address,
    };
  }

  //mocked list
  static getMockedList() {
    return [];
    // return [
    //   CensusEntity(
    //     field: PolygonEntity.getMockedList().first,
    //     fullName: 'Joakim Doe',
    //     phone: '778890987',
    //     profit: 1000,
    //     production: 100,
    //     address: '123, rue 123, ville 123',
    //   ),
    //   CensusEntity(
    //     field: PolygonEntity.getMockedList().first,
    //     fullName: 'Jane Doe',
    //     phone: '7674737263',
    //     profit: 2000,
    //     production: 200,
    //     address: '987, rue 987, ville 987',
    //   ),
    //   CensusEntity(
    //     field: PolygonEntity.getMockedList().first,
    //     fullName: 'John Doe',
    //     phone: '767729474',
    //     profit: 1000,
    //     production: 100,
    //     address: '123, rue 123, ville 123',
    //   ),
    //   CensusEntity(
    //     field: PolygonEntity.getMockedList().first,
    //     fullName: 'Amine ROUISSI',
    //     phone: '777992884',
    //     profit: 2000,
    //     production: 200,
    //     address: '987, rue 987, ville 987',
    //   ),
    //   CensusEntity(
    //     field: PolygonEntity.getMockedList().first,
    //     fullName: 'Dan Jones',
    //     phone: '787739944',
    //     profit: 1000,
    //     production: 100,
    //     address: '123, rue 123, ville 123',
    //   ),
    //   CensusEntity(
    //     field: PolygonEntity.getMockedList().first,
    //     fullName: 'Paul Smith',
    //     phone: '776627794',
    //     profit: 2000,
    //     production: 200,
    //     address: '987, rue 987, ville 987',
    //   ),
    //   CensusEntity(
    //     field: PolygonEntity.getMockedList().first,
    //     fullName: 'Phil Collins',
    //     phone: '766556678',
    //     profit: 1000,
    //     production: 100,
    //     address: '123, rue 123, ville 123',
    //   ),
    //   CensusEntity(
    //     field: PolygonEntity.getMockedList().first,
    //     fullName: 'Elon Musk',
    //     phone: '788829994',
    //     profit: 2000,
    //     production: 200,
    //     address: '987, rue 987, ville 987',
    //   ),
    //   CensusEntity(
    //     field: PolygonEntity.getMockedList().first,
    //     fullName: 'Yassine ROUISSI',
    //     phone: '775739985',
    //     profit: 1000,
    //     production: 100,
    //     address: '123, rue 123, ville 123',
    //   ),
    //   CensusEntity(
    //     field: PolygonEntity.getMockedList().first,
    //     fullName: 'Priscilla Telmon',
    //     phone: '773949505',
    //     profit: 2000,
    //     production: 200,
    //     address: '987, rue 987, ville 987',
    //   ),
    // ];
  }
}

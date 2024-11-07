import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class PolygonEntity extends Polygon {
  String? id;
  List<LatLng> coordinates;
  final String? type;
  String name;
  Color color;

  PolygonEntity({
    this.type,
    this.id,
    required this.name,
    required this.color,
    required this.coordinates,
    required super.polygonId,
  }) : super(
          consumeTapEvents: false,
          fillColor: Colors.transparent,
          geodesic: true,
          points: coordinates,
          strokeWidth: 3,
          strokeColor: const Color.fromARGB(255, 39, 7, 251),
          holes: [],
          visible: true,
          zIndex: 0,
          // holes: coordinates.map((e) => [e]).toList(),
        );

  PolygonEntity.empty()
      : this(
          type: "SOLAR_INSTALLATION",
          name: "Nouveau polygone",
          color: Colors.red,
          coordinates: [],
          polygonId: PolygonId(const Uuid().v4()),
        );

  //FromJson
  factory PolygonEntity.fromJson(Map<String, dynamic> json) {
    return PolygonEntity(
      polygonId: PolygonId(const Uuid().v4()),
      type: json['type'],
      coordinates: (json['features'] as List).map((e) {
        return LatLng(
            e['geometry']['coordinates'][0], e['geometry']['coordinates'][1]);
      }).toList(),
      name: json['name'],
      color:
          //random color
          Color.fromARGB(255, Random().nextInt(255), Random().nextInt(255),
              Random().nextInt(255)),
    );
  }

  LatLng get getAveragePosition {
    double lat = 0;
    double lng = 0;
    for (var element in coordinates) {
      lat += element.latitude;
      lng += element.longitude;
    }
    return LatLng(lat / coordinates.length, lng / coordinates.length);
  }

  PolygonEntity copy({
    String? id,
    String? name,
    List<LatLng>? coordinates,
    Color? color,
  }) {
    return PolygonEntity(
      polygonId: PolygonId(id ?? const Uuid().v4()),
      id: id ?? this.id,
      name: name ?? this.name,
      coordinates: coordinates ?? this.coordinates,
      color: color ?? this.color,
    );
  }

  //toJson
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type ?? "SOLAR_INSTALLATION",
      'features': coordinates
          .map((e) => {
                'type': 'Feature',
                'geometry': {
                  'coordinates': [e.latitude, e.longitude],
                  'type': 'Polygon'
                },
                'properties': {}
              })
          .toList()
    };
  }

  static List<PolygonEntity> getMockedList() {
    return [
      PolygonEntity(
        id: '1',
        name: 'Polygone témoin',
        polygonId: const PolygonId("1"),
        coordinates: const [
          LatLng(14.754795826353183, -17.46704266989064),
          LatLng(14.751102277749627, -17.4648110721782),
          LatLng(14.750562765402373, -17.460605368797058),
          LatLng(14.755086327516127, -17.460862860840802),
        ],
        color: Colors.red,
      ),
    ];
  }

  // static PolygonEntity getMockedPolygon() {
  //   return PolygonEntity(
  //     polygonId: PolygonId(Uuid().v4()),
  //     id: '1',
  //     name: 'Polygone témoin',
  //     coordinates: [
  //       //37.4221, -122.0852
  //       const LatLng(37.4221, -122.0852),
  //       //37.4274, -122.1697
  //       const LatLng(37.4274, -122.1697),
  //       //37.4219, -122.1731
  //       const LatLng(37.4219, -122.1731),
  //       //37.4174, -122.1697
  //       const LatLng(37.4174, -122.1697),
  //     ],
  //     color: Colors.red,
  //   );
  // }
}

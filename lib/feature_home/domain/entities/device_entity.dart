import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeviceEntity {
  String id;
  String name;
  LatLng position;
  String imageUrl;

  DeviceEntity({
    required this.id,
    required this.name,
    required this.position,
    this.imageUrl = 'assets/no_image.jpg',
  });

  DeviceEntity copyWith({
    String? id,
    String? name,
    LatLng? position,
  }) {
    return DeviceEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
    );
  }

  Widget getImage(BuildContext context) {
    //return an asset image is anot a network image
    if (imageUrl.startsWith("assets") ||
        !imageUrl.startsWith("http") ||
        !imageUrl.startsWith("https")) {
      return Image.asset(imageUrl);
    }
    //return a cached network image if image is not the default one
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      // width: width,
      // height: height,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) {
        return Image.asset(
          'assets/no_image.png',
          fit: BoxFit.cover,
          // width: width,
          // height: height,
        );
      },
    );
  }

  static List<DeviceEntity> getMockedList() {
    return [
      DeviceEntity(
        id: '1',
        name: 'Device 1',
        position: const LatLng(
          37.42796133580664,
          -122.085749655962,
        ),
      ),
      DeviceEntity(
        id: '2',
        name: 'Device 2',
        imageUrl: "assets/default.jpg",
        position: const LatLng(
          37.42796133580664,
          -122.085749655962,
        ),
      ),
      DeviceEntity(
        id: '3',
        name: 'Device 3',
        position: const LatLng(
          37.42796133580664,
          -122.085749655962,
        ),
      ),
    ];
  }
}

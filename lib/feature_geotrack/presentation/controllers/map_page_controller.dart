import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infiniteagent/core/build_context_extension.dart';
import 'package:infiniteagent/core/resources/polygon_entity.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

import '../../../config/services/services.dart';
import '../widgets/color_selection_widget.dart';

class MapPageController extends ChangeNotifier {
  late Function viewState;
  bool isLoading = true;
  int _optionIndex = 0;
  Set<Marker> markers = {};
  Set<Polygon> polygons = {};
  LocationData? currentLocation;
  Map<String, dynamic> polygonJson = {};
  bool isOnSelectionMode = false;
  List<PolygonEntity> polygonsList = [];
  Completer<GoogleMapController> mapsControllerCompleter = Completer();
  BitmapDescriptor userLocationMarker = BitmapDescriptor.defaultMarker;
  Location location = Location();
  int currentZoom = 18;
  LatLng cameraPosition = const LatLng(0, 0);
  LatLng userPosition = const LatLng(0, 0);
  bool fromForm = false;
  int get optionIndex => _optionIndex;

  set optionIndex(int value) {
    _optionIndex = value;
    notifyListeners();
  }

  Future addPositionTrackingListener() async {
    try {
      GoogleMapController mapController = await mapsControllerCompleter.future;
      location.onLocationChanged.listen((event) {
        currentLocation = event;
        cameraPosition = LatLng(
          event.latitude ?? cameraPosition.latitude,
          event.longitude ?? cameraPosition.longitude,
        );
        userPosition = cameraPosition;
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: cameraPosition,
              zoom: currentZoom.toDouble(),
            ),
          ),
        );
        refreshView();
      });
    } catch (e) {
      Services.debugLog(
          "Error in MapPageController.addPositionTrackingListener(): $e");
    }
  }

  void disposeLocation() {
    // Cancel any active subscriptions
    location.onLocationChanged.listen(null).cancel();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future getCurrentLocation(BuildContext context) async {
    try {
      await location.getLocation().then((LocationData cLoc) {
        currentLocation = cLoc;
      });
    } catch (e) {
      Services.debugLog("Error in MapPageController.getCurrentLocation(): $e");
    }
  }

  Future init(BuildContext context, Function setState, bool fromForm,
      PolygonEntity? polygon) async {
    try {
      await getCurrentLocation(context);
      cameraPosition = LatLng(
        currentLocation!.latitude!,
        currentLocation!.longitude!,
      );
      userPosition = cameraPosition;
      //TODO: get census polygon
      if (polygon != null) polygonsList.add(polygon);
      viewState = setState;
      polygonsList.map(
        (e) => e.copyWith(
          onTapParam: () {
            showDialog(
              context: context,
              builder: (context) {
                PolygonEntity polygon =
                    polygonsList.where((element) => element.id == e.id).first;
                return AlertDialog(
                  title: const Text("Informations"),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nom: ${polygon.name}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Nombre de sommets: ${polygon.coordinates.length}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //actions
                  //an edit button to edit the polygon
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.primaryColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        // editPolygon(polygon);
                      },
                      child: const Text(
                        "Modifier",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        // deletePolygon(polygon);
                      },
                      child: const Text(
                        "Supprimer",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      );
      polygons.addAll(polygonsList);
      addPositionTrackingListener();
      setCustomMarkerIcon();
      isLoading = false;
      refreshView();
    } catch (e) {
      Services.debugLog("Error in MapPageController.init(): $e");
      rethrow;
    }
  }

  void refreshView() {
    notifyListeners();
    viewState(() {});
  }

  void setColor(BuildContext context) {
    try {
      //open a dialog to let the user choose the color of the polygon
      PolygonEntity toAdd = polygonsList.last;
      //generate an uuid
      toAdd.id = const Uuid().v4();
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Choisissez une couleur"),
            content: SingleChildScrollView(
              child: ColorSelectionWidget(),
            ),
          );
        },
      ).then((value) {
        polygons.add(
          Polygon(
            polygonId: PolygonId(polygonsList.length.toString()),
            points: toAdd.coordinates,
            strokeWidth: 2,
            strokeColor: toAdd.color,
            fillColor: toAdd.color.withOpacity(0.15),
            consumeTapEvents: true,
            onTap: //show a modal with info of the polygon
                () {
              showDialog(
                context: context,
                builder: (context) {
                  PolygonEntity polygon = polygonsList
                      .where((element) => element.id == toAdd.id)
                      .first;
                  return AlertDialog(
                    title: const Text("Informations"),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nom: ${polygon.name}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Nombre de sommets: ${polygon.coordinates.length}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    //actions
                    //an edit button to edit the polygon
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.primaryColor,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          // editPolygon(polygon);
                        },
                        child: const Text(
                          "Modifier",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          // deletePolygon(polygon);
                        },
                        child: const Text(
                          "Supprimer",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
        markers.clear();
        refreshView();
        // Navigator.pop(context, polygonsList.last);
      });
    } catch (e) {
      Services.debugLog("Error adding polygon: $e");
    }
  }

  void setCustomMarkerIcon() async {
    try {
      userLocationMarker = BitmapDescriptor.bytes(
        await getBytesFromAsset('assets/pin.png', 50),
      );
    } catch (e) {
      Services.debugLog("Error in MapPageController.setCustomMarkerIcon(): $e");
    }
  }

  void setName(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    //open a dialog to let the user choose the name of the polygon
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Choisissez un nom"),
          content: SingleChildScrollView(
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "Nom",
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                polygonsList.last.name = nameController.text;
                refreshView();
                setColor(context);
              },
              child: const Text("Valider"),
            ),
          ],
        );
      },
    );
  }

  void validatePolygon(BuildContext context) {
    isOnSelectionMode = false;
    refreshView();
    polygonJson = {
      "type": "",
      "features": [
        {
          "type": "",
          "geometry": {
            "coordinates": [
              [
                ...polygonsList.last.coordinates.map((e) => [
                      e.longitude,
                      e.latitude,
                    ])
              ]
            ],
            "type": ""
          },
          "properties": {}
        }
      ]
    };
    Services.debugLog("polygonJson: $polygonJson");
    setName(context);
  }
}

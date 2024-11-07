import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infiniteagent/core/build_context_extension.dart';
import 'package:provider/provider.dart';

import '../../../config/services/services.dart';
import '../../../core/resources/polygon_entity.dart';
import '../controllers/map_page_controller.dart';

class MapPage extends StatefulWidget {
  final bool fromForm;
  final PolygonEntity? polygon;
  const MapPage({
    super.key,
    this.fromForm = false,
    this.polygon,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapPageController controller;
  bool hasError = false;
  bool _isMapReady = false;
  @override
  Widget build(BuildContext context) {
    MapPageController controller = context.read<MapPageController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 5,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        // toolbarHeight: context.height * 0.08,
        flexibleSpace: Container(
          height: context.height * 0.12,
          width: context.width,
          margin: EdgeInsets.only(
            top: context.height * 0.04,
          ),
          decoration: BoxDecoration(
            color: context.white,
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.5),
            //     spreadRadius: 0.1,
            //     blurRadius: 8,
            //     offset: const Offset(1, 1),
            //   ),
            // ],
          ),
          child: SizedBox(
            height: context.height * 0.08,
            width: context.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: context.width * 0.04,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: context.height * 0.03,
                  ),
                ),
                SizedBox(
                  width: context.width * 0.04,
                ),
                Text(
                  "Geotrack",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: context.height * 0.023,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
      body: (!_isMapReady || controller.currentLocation == null)
          ? Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                child: Theme(
                    data: ThemeData(
                      colorScheme: ColorScheme.fromSwatch().copyWith(
                        secondary: Colors.white,
                      ),
                    ),
                    child: hasError
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.clear_circled,
                                color: Colors.grey.withOpacity(0.4),
                                size: context.height * 0.08,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Une erreur s'est produite",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: context.height * 0.018,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : CupertinoActivityIndicator(
                            color: Colors.grey.withOpacity(.7),
                          )),
              ),
            )
          : Stack(
              alignment: Alignment.center,
              children: [
                // GoogleMap widget
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: GoogleMap(
                    //on zoom change
                    onCameraMove: (cameraPosition) {
                      controller.currentZoom = cameraPosition.zoom.toInt();
                      controller.cameraPosition = cameraPosition.target;
                      setState(() {});
                    },
                    onTap: (position) {
                      if (!controller.isOnSelectionMode) return;
                      if (!(controller.optionIndex == 1)) return;
                      try {
                        if (controller.polygonsList.isEmpty)
                          controller.polygonsList.add(
                            PolygonEntity(
                              id: '${controller.polygonsList.length + 1}',
                              polygonId: PolygonId(
                                '${controller.polygonsList.length + 1}',
                              ),
                              name: '${controller.polygonsList.length + 1}',
                              coordinates: const [],
                              color: Colors.blue,
                            ),
                          );

                        Services.debugLog(
                            "The polygon we are working on is: ${controller.polygonsList.last.id} with lenght: ${controller.polygonsList.last.coordinates.length}");
                        controller.polygonsList.last =
                            controller.polygonsList.last.copy(
                          coordinates: [
                            ...controller.polygonsList.last.coordinates,
                            position,
                          ],
                        );
                        Services.debugLog("new coordinate added to polygon");
                        controller.markers.add(
                          Marker(
                            markerId: MarkerId(position.toString()),
                            zIndex: controller
                                .polygonsList.last.coordinates.length
                                .toDouble(),

                            position: position,
                            draggable: true,
                            // onDrag: (newPos){
                            // },
                          ),
                        );
                        Services.debugLog("new marker added to list");
                        setState(() {});
                      } catch (error) {
                        Services.debugLog("Error while adding point: $error");
                      }
                    },
                    initialCameraPosition: CameraPosition(
                      target: controller.cameraPosition,
                      zoom: controller.currentZoom.toDouble(),
                    ),
                    onMapCreated: (mapsController) {
                      controller.mapsControllerCompleter
                          .complete(mapsController);
                      setState(() {});
                    },
                    // draws polygons on map using peakPoints
                    polygons: controller.polygons,
                    markers: {
                      Marker(
                        markerId: const MarkerId('userLocation'),
                        position: controller.userPosition,
                        icon: controller.userLocationMarker,
                      ),
                      ...controller.markers,
                    },
                    // onTap: (location) {
                    //   if (!widget.isOnSelectionMode) return;
                    //   widget.polygonsList.last.coordinates.add(location);
                    //   widget.markers.add(
                    //     Marker(
                    //       markerId: MarkerId(location.toString()),
                    //       position: location,
                    //     ),
                    //   );
                    //   setState(() {});
                    // },
                  ),
                ),
                Visibility(
                  visible: controller.isOnSelectionMode,
                  child: Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onVerticalDragEnd: (_) {
                        controller.isOnSelectionMode = false;
                        setState(() {});
                      },
                      child: Container(
                        height: context.height * 0.35,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 5,
                              width: context.width * 0.25,
                              margin: const EdgeInsets.only(
                                top: 10,
                                bottom: 15,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Text(
                              "Ajouter une ressource",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: context.height * 0.017,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              height: context.height * 0.06,
                              width: double.infinity,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      controller.optionIndex = 0;
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: context.width * 0.45,
                                      decoration: controller.optionIndex == 0
                                          ? BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color:
                                                      controller.optionIndex ==
                                                              0
                                                          ? context.primaryColor
                                                          : Colors.transparent,
                                                  width: 2,
                                                ),
                                              ),
                                            )
                                          : null,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/walk.png",
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Marcher",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    context.height * 0.016,
                                                color:
                                                    controller.optionIndex == 0
                                                        ? context.primaryColor
                                                        : Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      controller.optionIndex = 1;
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: context.width * 0.45,
                                      decoration: controller.optionIndex == 1
                                          ? BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: context.primaryColor,
                                                  width: 2,
                                                ),
                                              ),
                                            )
                                          : null,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                                "assets/track.svg"),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Traquer",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    context.height * 0.016,
                                                color:
                                                    controller.optionIndex == 1
                                                        ? context.primaryColor
                                                        : Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: context.width * 0.85,
                              margin: const EdgeInsets.only(
                                top: 25,
                                bottom: 25,
                              ),
                              child: Text(
                                controller.optionIndex == 0
                                    ? "Marchez et ajoutez un point à chaque fois que vous arrivez à un coin de la zone que vous voulez délimiter."
                                    : "Placez les points pour encadrer la zone que vous souhaitez enregistrer",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: context.height * 0.012,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (!controller.isOnSelectionMode) return;
                                if (!(controller.optionIndex == 1)) return;
                                try {
                                  LatLng location = LatLng(
                                    controller.currentLocation!.latitude!,
                                    controller.currentLocation!.longitude!,
                                  );
                                  if (controller.polygonsList.isEmpty)
                                    controller.polygonsList.add(
                                      PolygonEntity(
                                        id: '${controller.polygonsList.length + 1}',
                                        polygonId: PolygonId(
                                          '${controller.polygonsList.length + 1}',
                                        ),
                                        name:
                                            '${controller.polygonsList.length + 1}',
                                        coordinates: const [],
                                        color: Colors.blue,
                                      ),
                                    );

                                  Services.debugLog(
                                      "The polygon we are working on is: ${controller.polygonsList.last.id} with lenght: ${controller.polygonsList.last.coordinates.length}");
                                  controller.polygonsList.last =
                                      controller.polygonsList.last.copy(
                                    coordinates: [
                                      ...controller
                                          .polygonsList.last.coordinates,
                                      location,
                                    ],
                                  );
                                  controller.markers.add(
                                    Marker(
                                      markerId: MarkerId(location.toString()),
                                      zIndex: controller
                                          .polygonsList.last.coordinates.length
                                          .toDouble(),
                                      position: location,
                                      draggable: true,
                                      // onDrag: (newPos){
                                      // },
                                    ),
                                  );
                                  setState(() {});
                                } catch (error) {
                                  Services.debugLog(
                                      "Something wrong happened while adding a point: $error");
                                }
                              },
                              child: Container(
                                width: context.width * 0.9,
                                padding: EdgeInsets.symmetric(
                                  vertical: context.height * 0.01,
                                ),
                                margin: EdgeInsets.only(
                                  bottom: context.height * 0.015,
                                ),
                                decoration: BoxDecoration(
                                  color: context.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: Text(
                                    "Ajouter un point",
                                    style: TextStyle(
                                      color: context.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: context.height * 0.013,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (controller
                                        .polygonsList.last.coordinates.length <
                                    3) {
                                  return;
                                }
                                controller.validatePolygon(context);
                              },
                              child: Container(
                                width: context.width * 0.9,
                                padding: EdgeInsets.symmetric(
                                  vertical: context.height * 0.01,
                                ),
                                margin: EdgeInsets.only(
                                  bottom: context.height * 0.02,
                                ),
                                decoration: BoxDecoration(
                                  color: context.primaryColor,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: Text(
                                    "Terminer",
                                    style: TextStyle(
                                      color: context.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: context.height * 0.013,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Positioned(
                //   bottom: 20,
                //   left: 20,
                //   child: Visibility(
                //     visible: !controller.isOnSelectionMode,
                //     child: ElevatedButton(
                //       onPressed: () {
                //         setState(() {
                //           controller.isOnSelectionMode = true;
                //           if (controller
                //               .polygonsList.last.coordinates.isNotEmpty) {
                //             controller.polygonsList.add(
                //               PolygonEntity(
                //                 id: '${controller.polygonsList.length + 1}',
                //                 polygonId: PolygonId(
                //                   '${controller.polygonsList.length + 1}',
                //                 ),
                //                 name: '${controller.polygonsList.length + 1}',
                //                 coordinates: [],
                //                 color: Colors.red,
                //               ),
                //             );
                //           }
                //         });
                //       },
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: context.primaryColor,
                //         padding: const EdgeInsets.all(20),
                //       ),
                //       child: Text(
                //         "Ajouter une ressource",
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: context.width * 0.04,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // Positioned(
                //   bottom: 100,
                //   left: 20,
                //   child: Visibility(
                //     visible: controller.isOnSelectionMode,
                //     child: ElevatedButton(
                //       onPressed: () {
                //         Services.getUserLocation().then((_) {
                //           LatLng location = LatLng(
                //             UserEntity.currentPosition!.latitude,
                //             UserEntity.currentPosition!.longitude,
                //           );
                //           if (!controller.isOnSelectionMode) return;
                //           controller.polygonsList.last.coordinates
                //               .add(location);
                //           controller.markers.add(
                //             Marker(
                //               markerId: MarkerId(location.toString()),
                //               position: location,
                //             ),
                //           );
                //           setState(() {});
                //         });
                //       },
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: context.primaryColor,
                //         padding: const EdgeInsets.all(20),
                //       ),
                //       child: const Icon(
                //         Icons.add,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
                // Positioned(
                //   bottom: 20,
                //   left: 20,
                //   child: Visibility(
                //     visible: controller.isOnSelectionMode,
                //     child: ElevatedButton(
                //       onPressed: () {
                //         if (controller.polygonsList.last.coordinates.length <
                //             3) {
                //           return;
                //         }
                //         controller.validatePolygon(context, setState);
                //       },
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: context.primaryColor,
                //         padding: const EdgeInsets.all(20),
                //       ),
                //       child: const Icon(
                //         Icons.check,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
                // Positioned(
                //   top: 20,
                //   child: Visibility(
                //     visible: controller.isOnSelectionMode,
                //     child: Container(
                //       decoration: BoxDecoration(
                //         color: context.primaryColor,
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       child: const Padding(
                //         padding: EdgeInsets.all(8.0),
                //         child: Text(
                //           "Positionnez vous au niveau du prochain sommet",
                //           style: TextStyle(
                //             color: Colors.white,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
      floatingActionButton:
          //create channel button
          Visibility(
        visible:
            !(!_isMapReady || controller.currentLocation == null || hasError),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Visibility(
              visible: controller.polygonsList.isNotEmpty &&
                  !controller.isOnSelectionMode,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: context.height * 0.04,
                  left: 40,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    try {
                      Navigator.pop(context, controller.polygonsList.last);
                    } catch (e) {
                      Services.debugLog(
                          "Hey, there is a problem getting back: $e");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !controller.isOnSelectionMode,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: context.height * 0.04,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      controller.isOnSelectionMode = true;
                      // if ( controller.polygonsList.last.coordinates.isNotEmpty) {
                      controller.polygonsList.add(
                        PolygonEntity(
                          id: '${controller.polygonsList.length + 1}',
                          polygonId: PolygonId(
                            '${controller.polygonsList.length + 1}',
                          ),
                          name: '${controller.polygonsList.length + 1}',
                          coordinates: const [],
                          color: Colors.red,
                        ),
                      );
                      // }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.primaryColor,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //stop listening to location changes
    controller.disposeLocation();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = context.read<MapPageController>();
    _initializeMap();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> _initializeMap() async {
    try {
      await controller.init(
        context,
        setState,
        widget.fromForm,
        widget.polygon,
      );
      if (mounted) {
        setState(() {
          _isMapReady = true;
        });
      }
    } catch (e) {
      Services.debugLog('Error initializing map: $e');
      hasError = true;
      if (mounted) {
        setState(() {});
      }
      // Handle error appropriately
    }
  }
}

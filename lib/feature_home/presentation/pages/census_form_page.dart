import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infiniteagent/core/build_context_extension.dart';
import 'package:infiniteagent/feature_home/presentation/widgets/title_section_widget.dart';
import 'package:provider/provider.dart';

import '../../../feature_geotrack/presentation/pages/map_page.dart';
import '../controllers/census_form_controller.dart';

class CensusFormPage extends StatefulWidget {
  const CensusFormPage({
    super.key,
  });

  @override
  State<CensusFormPage> createState() => _CensusFormPageState();
}

class _CensusFormPageState extends State<CensusFormPage> {
  late CensusFormController controller;
  @override
  Widget build(BuildContext context) {
    final Completer<GoogleMapController> mapController = Completer();
    // ignore: unused_local_variable
    double currentZoom = 17;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 5,
        toolbarHeight: context.height * 0.08,
        flexibleSpace: Container(
          height: context.height * 0.08,
          width: context.width,
          margin: EdgeInsets.only(
            top: context.height * 0.05,
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
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    CupertinoIcons.back,
                    color: context.black,
                    size: context.height * 0.03,
                  ),
                ),
                SizedBox(
                  width: context.width * 0.04,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Recensement",
                      style: TextStyle(
                        color: context.black,
                        fontSize: context.height * 0.018,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
        onTap: () => controller.save(context),
        child: Container(
          height: 50,
          width: context.width,
          padding: EdgeInsets.symmetric(
            vertical: context.height * 0.01,
          ),
          margin: EdgeInsets.only(
            bottom: 0,
            left: context.width * 0.07,
            right: context.width * 0.07,
          ),
          decoration: BoxDecoration(
            color: context.primaryColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              "Enregistrer",
              style: TextStyle(
                color: context.white,
                fontWeight: FontWeight.bold,
                fontSize: context.height * 0.016,
              ),
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          //remove focus
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 15,
                  ),
                  child: InkWell(
                    onTap: () => controller.pickPolygon(context),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                      child: DottedBorder(
                        color: Colors.grey.withOpacity(.7),
                        strokeWidth: 1.5,
                        strokeCap: StrokeCap.round,
                        borderType: BorderType.RRect,
                        dashPattern: const [8, 8],
                        radius: const Radius.circular(15),
                        child: Container(
                          height: context.height * 0.18,
                          width: context.height * 0.18,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: controller.polygon == null
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/add_polygon.svg",
                                        // color: Colors.grey.withOpacity(.7),
                                        colorFilter: ColorFilter.mode(
                                          Colors.grey.withOpacity(.7),
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "Ajouter une zone",
                                        style: TextStyle(
                                          color: Colors.grey.withOpacity(.7),
                                          fontSize: context.height * 0.015,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : StatefulBuilder(builder: (context, refresh) {
                                  CameraPosition cameraPosition =
                                      CameraPosition(
                                    target: LatLng(
                                      controller
                                          .polygon!.coordinates.first.latitude,
                                      controller
                                          .polygon!.coordinates.first.longitude,
                                    ),
                                    zoom: currentZoom,
                                  );
                                  return GoogleMap(
                                    onTap: (_) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const MapPage(),
                                        ),
                                      );
                                    },
                                    compassEnabled: false,
                                    myLocationButtonEnabled: false,
                                    zoomControlsEnabled: false,
                                    zoomGesturesEnabled: true,
                                    mapToolbarEnabled: false,
                                    //on zoom change
                                    onCameraMove: (cameraPosition) {
                                      currentZoom =
                                          cameraPosition.zoom.toDouble();
                                      setState(() {});
                                      refresh(() {});
                                    },
                                    initialCameraPosition: cameraPosition,
                                    onMapCreated: (controller) {
                                      mapController.complete(controller);
                                    },
                                    // draws polygons on map using peakPoints
                                    polygons: <Polygon>{
                                      controller.polygon!,
                                    },
                                    // markers: {
                                    //   Marker(
                                    //     markerId: const MarkerId('userLocation'),
                                    //     position: controller.polygon!.getAveragePosition,
                                    //     icon: userLocationMarker,
                                    //   ),
                                    //   ...widget.markers,
                                    // },
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
                                  );
                                }),
                        ),
                      ),
                    ),
                  ),
                ),
                //TODO: Implement address
                // Text(
                //   controller.addressCtrl.text,
                //   style: TextStyle(
                //     color: context.black,
                //     fontWeight: FontWeight.bold,
                //     fontSize: context.height * 0.013,
                //   ),
                // ),
                // SizedBox(
                //   height: context.height * 0.01,
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.width * 0.06,
                  ),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        CustomListTileWidget(
                          title: "Informations",
                          titleSize: context.height * 0.018,
                          subtitle: "",
                          trailing: Container(),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        //First name
                        TextFormField(
                          controller: controller.firstNameCtrl,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.05),
                            //border color: context.primaryColor
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            hintText: 'Prénom',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un prénom';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: controller.lastNameCtrl,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.05),
                            //border color: context.primaryColor
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            hintText: 'Nom',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un nom';
                            }
                            return null;
                          },
                        ),

                        TextFormField(
                          controller: controller.phoneCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.05),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'Téléphone',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un numéro de téléphone';
                            }
                            return null;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Est-ce votre numéro sur whatsapp ? ",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: context.height * 0.015,
                              ),
                            ),

                            //switch to enable or disable delivery
                            CupertinoSwitch(
                              value: controller.isWhatsappVisible,
                              activeColor: context.primaryColor,
                              onChanged: (value) {
                                controller.isWhatsappVisible = value;
                                setState(() {});
                              },
                            ),
                          ],
                        ),

                        if (!controller.isWhatsappVisible)
                          TextFormField(
                            controller: controller.whatsappCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.05),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Numéro Whatsapp',
                            ),
                          ),
                        TextFormField(
                          controller: controller.addressCtrl,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.05),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'Adresse',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer une adresse';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 400,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    controller = context.read<CensusFormController>()..init(setState);
    super.initState();
  }
}

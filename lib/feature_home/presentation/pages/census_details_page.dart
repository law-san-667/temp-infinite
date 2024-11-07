import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infiniteagent/core/build_context_extension.dart';
import 'package:infiniteagent/feature_geotrack/presentation/pages/map_page.dart';
import 'package:infiniteagent/feature_home/domain/entities/census_entity.dart';
import 'package:infiniteagent/feature_home/presentation/controllers/census_details_controller.dart';
import 'package:infiniteagent/feature_home/presentation/widgets/title_section_widget.dart';
import 'package:provider/provider.dart';

class CensusDetailsPage extends StatefulWidget {
  final CensusEntity census;
  const CensusDetailsPage({
    super.key,
    required this.census,
  });

  @override
  State<CensusDetailsPage> createState() => _CensusDetailsPageState();
}

class _CensusDetailsPageState extends State<CensusDetailsPage> {
  late CensusDetailsController controller;
  @override
  Widget build(BuildContext context) {
    final Completer<GoogleMapController> mapController = Completer();
    controller.viewState = setState;
    // ignore: unused_local_variable
    double currentZoom = 13;
    return controller.census == null
        ? const Scaffold(
            body: Center(
              child: CupertinoActivityIndicator(),
            ),
          )
        : Scaffold(
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
                      Container(
                        height: context.height * 0.044,
                        width: context.height * 0.044,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: NetworkImage(
                              controller.getCensus.userInitials,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: context.width * 0.025,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.getCensus.fullName,
                            style: TextStyle(
                              color: context.black,
                              fontSize: context.height * 0.018,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            controller.getCensus.phone,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: context.height * 0.014,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          CupertinoIcons.ellipsis_vertical,
                          color: context.black,
                          size: context.height * 0.03,
                        ),
                        onPressed: () {
                          //dropdown menu with update, delete
                          showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(
                              context.width * 0.8,
                              context.height * 0.1,
                              context.width * 0.1,
                              context.height * 0.1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Colors.white,
                            // shadowColor: Colors.black,
                            elevation: 1,
                            // surfaceTintColor: Colors.black,
                            items: [
                              PopupMenuItem(
                                onTap: () {
                                  if (controller.isUpdating) return;
                                  setState(() {
                                    controller.isUpdating = true;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.width * 0.015,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.pencil,
                                        color: context.black,
                                        size: context.height * 0.02,
                                      ),
                                      SizedBox(
                                        width: context.width * 0.02,
                                      ),
                                      Text(
                                        "Modifier",
                                        style: TextStyle(
                                          color: context.black,
                                          fontSize: context.height * 0.016,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.width * 0.015,
                                    vertical: context.height * 0.00,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.delete,
                                        color: Colors.red,
                                        size: context.height * 0.02,
                                      ),
                                      SizedBox(
                                        width: context.width * 0.02,
                                      ),
                                      Text(
                                        "Supprimer",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: context.height * 0.016,
                                          //roboto condensed
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Visibility(
              visible: controller.isUpdating,
              child: InkWell(
                // onTap: () => controller.save(context),
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
            ),
            body: SingleChildScrollView(
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
                            child: controller.getCensus.field.id == null
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/add_polygon.svg",
                                          colorFilter: 
                                          // Colors.grey.withOpacity(.7),
                                          ColorFilter.mode(
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
                                : GoogleMap(
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
                                    mapToolbarEnabled: false,

                                    //on zoom change
                                    onCameraMove: (cameraPosition) {
                                      currentZoom =
                                          cameraPosition.zoom.toDouble();

                                      setState(() {});
                                    },
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(
                                        controller.getCensus.field.coordinates
                                            .first.latitude,
                                        controller.getCensus.field.coordinates
                                            .first.longitude,
                                      ),
                                      zoom: currentZoom,
                                    ),
                                    onMapCreated: (controller) {
                                      mapController.complete(controller);
                                    },
                                    // draws polygons on map using peakPoints
                                    polygons: <Polygon>{
                                      controller.getCensus.field,
                                    },
                                    // markers: {
                                    //   Marker(
                                    //     markerId: const MarkerId('userLocation'),
                                    //     position: controller.getCensus.field.getAveragePosition,
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
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    controller.getCensus.address,
                    style: TextStyle(
                      color: context.black,
                      fontWeight: FontWeight.bold,
                      fontSize: context.height * 0.013,
                    ),
                  ),
                  SizedBox(
                    height: context.height * 0.01,
                  ),
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
                            readOnly: !controller.isUpdating,
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
                            readOnly: !controller.isUpdating,
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
                            readOnly: !controller.isUpdating,
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

                          if (controller.isWhatsappVisible)
                            TextFormField(
                              readOnly: !controller.isUpdating,
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
                            readOnly: !controller.isUpdating,
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
                  SizedBox(
                    height: context.height * 0.1,
                  ),
                ],
              ),
            ),
          );
  }

  @override
  void initState() {
    controller = context.read<CensusDetailsController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.init(context, setState, widget.census);
    });
    super.initState();
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:infiniteagent/core/resources/user_entity.dart';
import 'package:infiniteagent/main.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../core/build_context_extension.dart';
import '../../core/use_cases/logout_use_case.dart';
import '../../injection_container.dart';

class Services {
  static Map<String, String> header = {
    'content-type': 'application/json',
    'accept': '*/*',
  };

  static AppBar appBar(
    BuildContext context, {
    List<Widget> leftIcons = const [],
    List<Widget> rightIcons = const [],
    String text = "Pulsar Infinite",
  }) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: isPortrait ? context.height * 0.08 : context.width * 0.07,
      flexibleSpace: Container(
        height: isPortrait ? context.height * 0.08 : context.width * 0.07,
        decoration: BoxDecoration(color: context.primaryColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: context.width * 0.32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ...leftIcons,
                ],
              ),
            ),
            SizedBox(
              width: context.width * 0.35,
              height: context.width * 0.2,
              child: Center(
                child:
                    //  text == null
                    //     ? Padding(
                    //         padding: const EdgeInsets.all(15),
                    //         child: SvgPicture.asset(
                    //           ,
                    //           fit: BoxFit.fitWidth,
                    //         ),
                    //       )
                    //     :
                    Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: context.width * 0.045,
                    color: context.white,
                  ),
                ),
              ),
            ),
            //right section with search button
            SizedBox(
              width: context.width * 0.32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: context.width * 0.02,
                  ),
                  ...rightIcons,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  static void debugLog(String message) {
    if (kDebugMode) {
      dev.log(message);
    }
  }

  // get address from lat and lon using geocoding
  static Future<String> getAddressFromLatLng(double lat, double lon) async {
    List<geocoding.Placemark> placemarks =
        await geocoding.placemarkFromCoordinates(lat, lon);
    geocoding.Placemark place = placemarks[0];
    String address = "${place.street}, ${place.postalCode}, ${place.locality}";
    return address;
  }

  static StreamSubscription getInternetListener(BuildContext context) {
    return InternetConnection().onStatusChange.listen((event) {
      if (event == InternetStatus.connected) {
        removeSnackBars(context);
        debugLog("Internet connected");
        if (isLaunched) {
          showSnackBar(
            context,
            message: "Connexion internet rétablie",
            backgroundColor: Colors.green,
            duration: 4,
          );
        }
        // setAppState((){});
      } else {
        removeSnackBars(context);
        debugLog("Internet disconnected");
        showSnackBar(
          context,
          message: "Veuillez vérifier votre connetion internet",
          backgroundColor: Colors.orange,
          duration: 86400,
        );
        isLaunched = true;
        // callSetGlobalState();
      }
    });
  }

  static Future<void> getUserLocation() async {
    try {
      bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        throw "Location service are disabled";
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw "Location permissions are denied !";
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw "Location permission is denied forever, we cannot perform this request !";
      }
      UserEntity.currentPosition =
          await Geolocator.getCurrentPosition().then((position) {
        sp.setString(
          'lastUserLoc',
          jsonEncode({
            'lat': position.latitude,
            'lon': position.longitude,
            'accuarcy': position.accuracy,
            'altitude': position.altitude,
            'altitudeAccuarcy': position.altitudeAccuracy,
            'heading': position.heading,
            'headingAccuarcy': position.headingAccuracy,
          }),
        );
        return position;
      });
    } catch (e) {
      debugLog("Error in getUserLocation: $e");
      if (sp.getString('lastUserLoc') != null) {
        Map<String, dynamic> lastLoc = jsonDecode(sp.getString('lastUserLoc')!);
        UserEntity.currentPosition = Position(
          timestamp: DateTime.now(),
          latitude: lastLoc['lat'],
          longitude: lastLoc['lon'],
          accuracy: lastLoc['accuracy'],
          altitude: lastLoc['altitude'],
          heading: lastLoc['heading'],
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: lastLoc['altitudeAccuarcy'],
          headingAccuracy: lastLoc['headingAccuarcy'],
        );
      }
    }
  }

  static void logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Déconnexion",
          ),
          content: const Text(
            "Voulez-vous vraiment vous déconnecter ?",
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Annuler",
                style: TextStyle(
                  color: context.primaryColor,
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(context.primaryColor),
              ),
              onPressed: () async {
                Navigator.pop(context);
                await sl<LogoutUseCase>().call().then((value) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                }).catchError((error) {
                  debugLog("Error logging out $error");
                  Services.showSnackBar(
                    context,
                    message: "Une erreur est survenue...",
                    backgroundColor: Colors.orange,
                  );
                });
              },
              child: const Text(
                "Confirmer",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  static void removeSnackBars(BuildContext context) {
    if (isSnackbarActive) {
      ScaffoldMessenger.of(context).clearSnackBars();
      isSnackbarActive = false;
    }
  }

  static void showSnackBar(
    BuildContext context, {
    required String message,
    int duration = 7,
    Color backgroundColor = Colors.orange,
    Color textColor = Colors.white,
  }) {
    try {
      if (!isSnackbarActive) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
              SnackBar(
                showCloseIcon: true,
                closeIconColor: textColor,
                duration: Duration(seconds: duration),
                behavior: SnackBarBehavior.floating,
                //margin bottom
                margin: const EdgeInsets.only(
                  bottom: 60,
                  left: 20,
                  right: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: Text(
                  message,
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
                backgroundColor: backgroundColor,
              ),
            )
            .closed
            .then((reason) {
          isSnackbarActive = false;
        }).catchError((error) {
          Services.debugLog("Error in showSnackBar: $error");
        });
        isSnackbarActive = true;
      } else {
        // showSnackBar(
        //   message: message,
        //   duration: duration,
        //   backgroundColor: backgroundColor,
        //   textColor: textColor,
        // );
      }
    } catch (e) {
      Services.debugLog("Error in showSnackBar: $e");
    }
  }
}

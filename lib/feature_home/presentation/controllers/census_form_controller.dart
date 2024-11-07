import 'package:flutter/material.dart';
import 'package:infiniteagent/feature_geotrack/presentation/pages/map_page.dart';
import 'package:infiniteagent/feature_home/domain/entities/census_entity.dart';
import 'package:infiniteagent/feature_home/domain/use_cases/create_census_use_case.dart';

import '../../../config/services/services.dart';
import '../../../core/resources/polygon_entity.dart';
import '../../../core/resources/user_entity.dart';
import '../../../injection_container.dart';

class CensusFormController extends ChangeNotifier {
  late GlobalKey<FormState> formKey;
  late Function viewState;
  CensusEntity entity = CensusEntity.empty();
  PolygonEntity? polygon;

  TextEditingController firstNameCtrl = TextEditingController();
  TextEditingController lastNameCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  num lat = 0;
  num lon = 0;
  TextEditingController whatsappCtrl = TextEditingController();
  bool isPasswordVisible = false;
  bool isWhatsappVisible = false;

  void init(Function setState) {
    formKey = GlobalKey<FormState>();
    isPasswordVisible = false;
    isWhatsappVisible = false;
    viewState = setState;
    resetFields();
  }

  void pickPolygon(BuildContext context) async {
    polygon = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapPage(
          fromForm: true,
        ),
      ),
    );
    if (polygon != null) {
      Services.debugLog("Received polygon is: ${polygon!.toJson()}");
      lat = polygon!.coordinates.first.latitude;
      lon = polygon!.coordinates.first.longitude;
    }
    refreshView();
  }

  void refreshView() {
    notifyListeners();
    viewState(() {});
  }

  void resetFields() {
    entity = CensusEntity.empty();
    firstNameCtrl.text = '';
    lastNameCtrl.text = '';
    phoneCtrl.text = '';
    addressCtrl.text = '';
    lat = 0;
    lon = 0;
    whatsappCtrl.text = '';
    polygon = null;
  }

  void save(BuildContext context) {
    if (formKey.currentState!.validate()) {
      entity = CensusEntity(
        firstName: firstNameCtrl.text.trim(),
        lastName: lastNameCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        address: addressCtrl.text.trim(),
        lat: lat < 1 ? UserEntity.currentPosition?.latitude ?? 0 : lat,
        lon: lon < 1 ? UserEntity.currentPosition?.longitude ?? 0 : lon,
        whatsapp: isWhatsappVisible ? whatsappCtrl.text.trim() : phoneCtrl.text,
        field: PolygonEntity.empty(),
      );

      sl<CreateCensusUseCase>().call(entity).then((_) {
        Navigator.pop(context);
        Services.showSnackBar(
          context,
          message: "Recensement effectué avec succès",
          backgroundColor: Colors.green,
        );
      }).catchError((error) {
        Services.showSnackBar(
          context,
          message: error,
          backgroundColor: Colors.orange,
        );
      });
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    viewState(() {});
  }

  void toggleWhatsappVisibility() {
    isWhatsappVisible = !isWhatsappVisible;
    viewState(() {});
  }
}

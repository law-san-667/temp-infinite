import 'package:flutter/material.dart';
import 'package:infiniteagent/config/services/services.dart';
import 'package:infiniteagent/feature_home/domain/entities/census_entity.dart';
import 'package:infiniteagent/feature_home/domain/use_cases/update_census_use_case.dart';

import '../../../core/resources/polygon_entity.dart';
import '../../../feature_geotrack/presentation/pages/map_page.dart';
import '../../../injection_container.dart';

class CensusDetailsController extends ChangeNotifier {
  CensusEntity? census;
  bool isUpdating = false;
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

  CensusEntity get getCensus => census!;

  void init(BuildContext context, Function setState, CensusEntity census) {
    try {
      this.census = census;
      viewState = setState;
      formKey = GlobalKey<FormState>();
      isPasswordVisible = false;
      isWhatsappVisible = false;

      firstNameCtrl.text = census.firstName;
      lastNameCtrl.text = census.lastName;
      phoneCtrl.text = census.phone;
      addressCtrl.text = census.address;
      lat = census.lat;
      lon = census.lon;
      whatsappCtrl.text = census.whatsapp ?? '';
      polygon = census.field;
      refreshView();
    } catch (e) {
      Services.debugLog("Error fetching census info: $e");
    }
  }

  void pickPolygon(BuildContext context) async {
    if (!isUpdating) return;
    polygon = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPage(
          fromForm: true,
          polygon: census!.field,
        ),
      ),
    );
    if (polygon != null) {
      Services.debugLog("Received polygon is: ${polygon!.toJson()}");
      census!.field = polygon!;
    }
    refreshView();
  }

  void refreshView() {
    notifyListeners();
    viewState(() {});
  }

  void save(BuildContext context) {
    if (formKey.currentState!.validate()) {
      entity = CensusEntity(
        firstName: firstNameCtrl.text.trim(),
        lastName: lastNameCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        address: addressCtrl.text.trim(),
        lat: lat,
        lon: lon,
        whatsapp: isWhatsappVisible ? whatsappCtrl.text.trim() : phoneCtrl.text,
        field: PolygonEntity.empty(),
      );

      sl<UpdateCensusUseCase>().call(entity).then((_) {
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
}

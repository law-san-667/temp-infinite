import 'package:flutter/material.dart';
import 'package:infiniteagent/feature_auth/domain/use_cases/login_use_case.dart';
import 'package:infiniteagent/injection_container.dart';

import '../../../config/services/services.dart';

class LoginPageController extends ChangeNotifier {
  late GlobalKey<FormState> formKey;
  late Function viewState;

  TextEditingController loginCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  bool isPasswordVisible = false;
  void init(Function setState) {
    formKey = GlobalKey<FormState>();
    isPasswordVisible = false;
    viewState = setState;
  }

  void login(BuildContext context) {
    if (formKey.currentState!.validate()) {
      sl<LoginUseCase>()
          .call(loginCtrl.text.trim(), passwordCtrl.text)
          .then((_) {
        Services.showSnackBar(context,
            message: "Connexion réussie !", backgroundColor: Colors.green);
        Navigator.pushReplacementNamed(context, '/home');
      }).catchError((error) {
        Services.debugLog("Error in login: $error");
        Services.showSnackBar(
          context,
          message: error,
          backgroundColor: Colors.orange,
        );
      });
    }
  }

  void refreshView() {
    notifyListeners();
    viewState(() {});
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    refreshView();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infiniteagent/feature_auth/presentation/controllers/login_page_controller.dart';
import 'package:provider/provider.dart';

import '../../../core/build_context_extension.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginPageController controller;
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
          ),
          automaticallyImplyLeading: false,
          flexibleSpace: Container(),
          backgroundColor: Colors.transparent,
          toolbarOpacity: 0,
          clipBehavior: Clip.none,
          toolbarHeight: 0,
          elevation: 0,
          forceMaterialTransparency: true,
        ),
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: InkWell(
          // onTap: () => Navigator.pushReplacementNamed(context, '/home'),

          onTap: () => controller.login(context),
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
                "Connexion",
                style: TextStyle(
                  color: context.white,
                  fontWeight: FontWeight.bold,
                  fontSize: context.height * 0.016,
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.width * 0.07,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: context.height * 0.1,
                      bottom: context.height * 0.03,
                    ),
                    child: SvgPicture.asset(
                      'assets/logo_blue.svg',
                      height: context.height * 0.22,
                    ),
                  ),
                  SizedBox(
                    height: context.height * 0.05,
                  ),
                  Text(
                    "Saisissez votre numéro de téléphone et mot de passe",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.black,
                      fontSize: context.height * 0.02,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: context.height * 0.05,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: controller.loginCtrl,
                    decoration: InputDecoration(
                      hintText: "Numéro de téléphone",
                      hintStyle: TextStyle(
                        color: context.black,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.black,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.black,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Veuillez saisir votre numéro de téléphone";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: context.height * 0.02,
                  ),
                  TextFormField(
                    obscureText: !controller.isPasswordVisible,
                    controller: controller.passwordCtrl,
                    decoration: InputDecoration(
                      hintText: "Mot de passe",
                      hintStyle: TextStyle(
                        color: context.black,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.black,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.black,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: context.black,
                        ),
                        onPressed: () {
                          controller.togglePasswordVisibility();
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Veuillez saisir votre mot de passe";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: context.height * 0.15,
                  ),
                  SizedBox(
                    height: context.height * 0.4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    controller = context.read<LoginPageController>()..init(setState);
    super.initState();
  }
}

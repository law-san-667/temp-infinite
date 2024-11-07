import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infiniteagent/feature_auth/domain/use_cases/check_if_logged_use_case.dart';
import 'package:infiniteagent/feature_auth/presentation/controllers/login_page_controller.dart';
import 'package:infiniteagent/feature_geotrack/presentation/controllers/map_page_controller.dart';
import 'package:infiniteagent/feature_home/presentation/controllers/census_details_controller.dart';
import 'package:infiniteagent/feature_home/presentation/controllers/census_form_controller.dart';
import 'package:infiniteagent/injection_container.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/services/services.dart';
import 'core/build_context_extension.dart';
import 'feature_auth/presentation/pages/landing_page.dart';
import 'feature_auth/presentation/pages/login_page.dart';
import 'feature_home/presentation/controllers/home_controller.dart';
import 'feature_home/presentation/pages/census_form_page.dart';
import 'feature_home/presentation/pages/home_page.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized
  await initializeDependencies();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
  ));
  runApp(const MyApp());
}

bool isLaunched = false;
bool isSnackbarActive = false;
late Function setAppState;
late SharedPreferences sp;
bool themeLight = true;

void changeTheme() {
  themeLight = !themeLight;
  setAppState();
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLaunching = true;
  String initialRoute = '/landing';

  @override
  Widget build(BuildContext context) {
    setAppState = () {
      setState(() {});
    };

    return FutureBuilder(
      future: SharedPreferences.getInstance().then((value) async {
        sp = value;
        await Future.delayed(const Duration(seconds: 2));
        await Services.getUserLocation();
        isLaunching = false;
        if (sp.getString("launchedBefore") == null) {
          initialRoute = '/landing';
        } else {
          initialRoute =
              await sl<CheckIfLoggedUseCase>().call() ? '/home' : '/login';
        }

        return initialRoute;
      }),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  color: context.primaryColor,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/logo_white.png',
                        color: Colors.white,
                        height: context.height * 0.3,
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'par',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: 5,
                              bottom: 5,
                            ),
                            child: SvgPicture.asset(
                              'assets/pulsar_group.svg',
                              height: 37,
                              width: 119.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => HomeController(),
              ),
              ChangeNotifierProvider(
                create: (context) => CensusDetailsController(),
              ),
              ChangeNotifierProvider(
                create: (context) => MapPageController(),
              ),
              ChangeNotifierProvider(
                create: (context) => LoginPageController(),
              ),
              ChangeNotifierProvider(
                create: (context) => CensusFormController(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Pulsar Infinite',
              theme: ThemeData(
                fontFamily: GoogleFonts.roboto().fontFamily,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: context.primaryColor, // Use Theme context safely
                ),
                useMaterial3: true,
              ),
              routes: {
                '/landing': (context) => const LandingPage(),
                '/home': (context) => const HomePage(),
                '/login': (context) => const LoginPage(),
                '/census_form': (context) => const CensusFormPage(),
              },
              initialRoute: initialRoute,
            ),
          );
        }
      },
    );
  }
}

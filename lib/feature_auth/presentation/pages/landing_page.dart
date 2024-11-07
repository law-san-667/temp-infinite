import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/build_context_extension.dart';
import '../../../main.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.width * 0.07,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: context.height * 0.07,
                bottom: context.height * 0.1,
              ),
              child: SvgPicture.asset(
                'assets/logo_blue.svg',
                height: context.height * 0.3,
              ),
            ),
            Text(
              "Bienvenue sur Pulsar Infinite",
              style: TextStyle(
                color: context.black,
                fontSize: context.height * 0.028,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: context.height * 0.02,
            ),
            Text(
              "Pour continuer, veuillez accepter notre :",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.black,
                fontSize: context.height * 0.018,
                fontWeight: FontWeight.w100,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: context.width * 0.1,
                right: context.width * 0.1,
                top: context.height * 0.045,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle,
                        color: context.black,
                        size: context.height * 0.006,
                      ),
                      SizedBox(
                        width: context.width * 0.025,
                      ),
                      Text(
                        "Politique de confidentialité",
                        style: TextStyle(
                          color: context.black,
                          fontSize: context.height * 0.018,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: context.height * 0.008,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle,
                        color: context.black,
                        size: context.height * 0.006,
                      ),
                      SizedBox(
                        width: context.width * 0.025,
                      ),
                      Text(
                        "Conditions d'utilisation",
                        style: TextStyle(
                          color: context.black,
                          fontSize: context.height * 0.018,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            //read & accept button
            InkWell(
              onTap: () {
                sp.setString("launchedBefore", "true");
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: context.height * 0.01,
                  horizontal: context.width * 0.18,
                ),
                margin: EdgeInsets.only(
                  bottom: context.height * 0.05,
                ),
                decoration: BoxDecoration(
                  color: context.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "J'ai lu et j'accepte",
                  style: TextStyle(
                    color: context.white,
                    fontWeight: FontWeight.bold,
                    fontSize: context.height * 0.018,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

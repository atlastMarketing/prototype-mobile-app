import 'package:atlast_mobile_app/screens/onboarding/signup_5_connect.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'signup_1_email.dart';
import 'signup_2_business_details.dart';
import 'signup_3_business_description.dart';
import 'signup_4_brand.dart';
import 'signup_confirm.dart';
import 'package:atlast_mobile_app/routes.dart';

class Onboarding extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;
  final void Function(RouteEnum) navigateToPage;

  const Onboarding({
    Key? key,
    required this.navKey,
    required this.navigateToPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // lazy loading
    return Navigator(
      key: navKey,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            switch (settings.name) {
              case "/onboarding-confirm":
                return OnboardingConfirm(
                  navKey: navKey,
                );
              case "/onboarding-5":
                return OnboardingConnect(
                  navKey: navKey,
                );
              case "/onboarding-4":
                return OnboardingBranding(
                  navKey: navKey,
                );
              case "/onboarding-3":
                return OnboardingBusinessDescription(
                  navKey: navKey,
                );
              case "/onboarding-2":
                return OnboardingBusinessDetails(
                  navKey: navKey,
                );
              case "/onboarding-1":
                return OnboardingEmail(
                  navKey: navKey,
                );
              default:
                return OnboardingLogin(
                  navKey: navKey,
                );
            }
          },
        );
      },
    );
  }
}

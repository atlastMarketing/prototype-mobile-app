import 'package:flutter/material.dart';

import 'login.dart';
import 'signup_1_email.dart';
import 'signup_2_business_details.dart';
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
              case "/onboarding-4":
                return OnboardingConfirm(
                  navKey: navKey,
                );
              case "/onboarding-3":
                return OnboardingConfirm(
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login.dart';
import 'signup_1_email.dart';
import 'signup_2_business.dart';
import 'signup_3_confirm.dart';

import 'package:atlast_mobile_app/routes.dart';
import 'package:atlast_mobile_app/data/user.dart';

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
              case "/creator-3":
                return OnboardingConfirm(
                  navKey: navKey,
                );
              case "/creator-2":
                return OnboardingBusiness(
                  navKey: navKey,
                );
              case "/creator-1":
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

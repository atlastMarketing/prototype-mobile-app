import 'package:atlast_mobile_app/screens/onboarding/create_3_confirm.dart';
import 'package:flutter/material.dart';

import './login.dart';
import './create_1_email.dart';
import './create_2_business.dart';

class Onboarding extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;
  final bool isUserLoggedIn;
  final void Function() handleSuccessfulLogin;
  final void Function() handleSuccessfulOnboarding;

  const Onboarding({
    Key? key,
    required this.navKey,
    required this.isUserLoggedIn,
    required this.handleSuccessfulLogin,
    required this.handleSuccessfulOnboarding,
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
              case "/create-3":
                return OnboardingConfirm(
                  navKey: navKey,
                  handleSuccessfulOnboarding: handleSuccessfulOnboarding,
                );
              case "/create-2":
                return OnboardingBusiness(
                  navKey: navKey,
                );
              case "/create-1":
                return OnboardingEmail(navKey: navKey);
              default:
                return OnboardingLogin(
                  navKey: navKey,
                  handleLogin: handleSuccessfulLogin,
                );
            }
          },
        );
      },
    );
  }
}

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/configs/layout.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';

class SettingsDashboard extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;
  final void Function() resetOnboarding;

  const SettingsDashboard({
    Key? key,
    required this.navKey,
    required this.resetOnboarding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: pagePadding,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const HeroHeading(text: "Settings Dashboard"),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Utility Functions for DEBUG:",
                            style: AppText.bodyBold,
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5)),
                          FilledButton(
                            onPressed: resetOnboarding,
                            child: const Text("Reset Onboarding"),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        extendBody: false,
      ),
    );
  }
}

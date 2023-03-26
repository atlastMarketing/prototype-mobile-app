import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:atlast_mobile_app/configs/layout.dart';
import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/data/user.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';

class SettingsDashboard extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;

  const SettingsDashboard({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  void _resetOnboarding(BuildContext ctx) {
    Provider.of<UserStore>(ctx, listen: false).setIsOnboarded(false);
  }

  void _triggerHelpPopups(BuildContext ctx) {
    bool currState = Provider.of<UserStore>(ctx, listen: false).hasHelpPopups;
    Provider.of<UserStore>(ctx, listen: false).setHasHelpPopups(!currState);
  }

  void _logout(BuildContext ctx) {
    Provider.of<UserStore>(ctx, listen: false).clear();
    Provider.of<UserStore>(ctx, listen: false).setIsOnboarded(false);
    Provider.of<UserStore>(ctx, listen: false).setHasHelpPopups(true);
  }

  @override
  Widget build(BuildContext context) {
    bool popupsStatus =
        Provider.of<UserStore>(context, listen: false).hasHelpPopups;

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
                            onPressed: () => _triggerHelpPopups(context),
                            child: popupsStatus
                                ? const Text("Deactivate Popups")
                                : const Text("Activate Popups"),
                          ),
                          FilledButton(
                            onPressed: () => _resetOnboarding(context),
                            child: const Text("Reset Onboarding"),
                          ),
                          FilledButton(
                            onPressed: () => _logout(context),
                            child: const Text("Logout"),
                          ),
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

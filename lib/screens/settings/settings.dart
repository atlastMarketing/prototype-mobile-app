import 'package:flutter/material.dart';

import 'settings_dashboard.dart';

class Settings extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;
  final void Function() resetOnboarding;

  const Settings({
    Key? key,
    required this.navKey,
    required this.resetOnboarding,
  }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    // lazy loading
    return Navigator(
      key: widget.navKey,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            switch (settings.name) {
              default:
                return SettingsDashboard(
                  navKey: widget.navKey,
                  resetOnboarding: widget.resetOnboarding,
                );
            }
          },
        );
      },
    );
  }
}

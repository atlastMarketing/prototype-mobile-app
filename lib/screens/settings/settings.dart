import 'package:atlast_mobile_app/screens/settings/user_profile.dart';
import 'package:flutter/material.dart';

import 'settings_debug.dart';

class Settings extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;

  const Settings({
    Key? key,
    required this.navKey,
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
              case "/debug":
                return SettingsDebug(navKey: widget.navKey);
              default:
                return UserProfile(navKey: widget.navKey);
            }
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

import 'home_dashboard.dart';

class Home extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;
  final void Function() handleCreate;

  const Home({
    Key? key,
    required this.navKey,
    required this.handleCreate,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    // lazy loading
    return WillPopScope(
      onWillPop: () async {
        if (widget.navKey.currentState != null &&
            widget.navKey.currentState!.canPop()) {
          // widget.navKey.currentState!.pop();
          return false;
        }
        return false;
      },
      child: Navigator(
        key: widget.navKey,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              switch (settings.name) {
                default:
                  return HomeDashboard(
                    navKey: widget.navKey,
                    handleCreate: widget.handleCreate,
                  );
              }
            },
          );
        },
      ),
    );
  }
}

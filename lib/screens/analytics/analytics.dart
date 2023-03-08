import 'package:flutter/material.dart';

import './analytics_dashboard.dart';

class Analytics extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;

  const Analytics({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  @override
  _AnalyticsState createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
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
                return AnalyticsDashboard(
                  navKey: widget.navKey,
                );
            }
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

import './calendar_dashboard.dart';

class Calendar extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;

  const Calendar({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
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
                return CalendarDashboard(
                  navKey: widget.navKey,
                );
            }
          },
        );
      },
    );
  }
}

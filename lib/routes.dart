import 'package:flutter/material.dart';

enum RouteEnum {
  home,
  calendar,
  analytics,
  settings,
}

class RouteData {
  final RouteEnum key;
  final String route;
  final String label;
  final IconData icon;
  final int navbarIdentifier;

  const RouteData({
    required this.key,
    required this.route,
    required this.label,
    required this.icon,
    required this.navbarIdentifier,
  });
}

const Map<RouteEnum, RouteData> routes = {
  RouteEnum.home: RouteData(
    key: RouteEnum.home,
    route: '/home',
    label: 'Home',
    icon: Icons.home,
    navbarIdentifier: 0,
  ),
  RouteEnum.calendar: RouteData(
    key: RouteEnum.calendar,
    route: '/calendar',
    label: 'Calendar',
    icon: Icons.calendar_month,
    navbarIdentifier: 1,
  ),
};

List<RouteEnum> routesInNavBar = routes.keys.toList();

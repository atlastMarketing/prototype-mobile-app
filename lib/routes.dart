import 'package:flutter/material.dart';

enum RouteEnum {
  home,
  calendar,
  creator,
  analytics,
  settings,
  // misc
  onboarding,
}

class RouteData {
  final RouteEnum key;
  final String route;
  final String label;
  final IconData icon;
  final int stackOrder;
  final int? navbarIdentifier;

  const RouteData({
    required this.key,
    required this.route,
    required this.label,
    required this.icon,
    required this.stackOrder,
    this.navbarIdentifier,
  });
}

const Map<RouteEnum, RouteData> routes = {
  RouteEnum.home: RouteData(
    key: RouteEnum.home,
    route: '/home',
    label: 'Home',
    icon: Icons.home,
    stackOrder: 0,
    navbarIdentifier: 0,
  ),
  RouteEnum.calendar: RouteData(
    key: RouteEnum.calendar,
    route: '/calendar',
    label: 'Calendar',
    icon: Icons.calendar_month,
    stackOrder: 1,
    navbarIdentifier: 1,
  ),
  RouteEnum.creator: RouteData(
    key: RouteEnum.creator,
    route: '/creator',
    label: 'Creator',
    icon: Icons.add,
    stackOrder: -1,
    navbarIdentifier: 2,
  ),
  RouteEnum.analytics: RouteData(
    key: RouteEnum.analytics,
    route: '/analytics',
    label: 'Analytics',
    icon: Icons.bar_chart,
    stackOrder: 2,
    navbarIdentifier: 3,
  ),
  RouteEnum.settings: RouteData(
    key: RouteEnum.settings,
    route: '/settings',
    label: 'Settings',
    icon: Icons.settings,
    stackOrder: 3,
    navbarIdentifier: 4,
  ),
  // misc routes
  // ignore: constant_identifier_names
  RouteEnum.onboarding: RouteData(
    key: RouteEnum.onboarding,
    route: '/onboarding',
    label: 'Onboarding',
    icon: Icons.join_full,
    stackOrder: -1,
  )
};

Map<RouteEnum, RouteData> routesInNavBar = {
  RouteEnum.home: routes[RouteEnum.home]!,
  RouteEnum.calendar: routes[RouteEnum.calendar]!,
  RouteEnum.creator: routes[RouteEnum.creator]!,
  RouteEnum.analytics: routes[RouteEnum.analytics]!,
  RouteEnum.settings: routes[RouteEnum.settings]!,
};

List<RouteEnum> routesInNavBarEnums = routesInNavBar.keys.toList();

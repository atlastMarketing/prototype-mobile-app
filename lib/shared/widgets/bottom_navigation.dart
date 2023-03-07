import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/routes.dart';

class BottomNavigation extends StatelessWidget {
  final RouteEnum currentRoute;
  final ValueChanged<RouteEnum> onNavbarTap;

  const BottomNavigation({
    Key? key,
    required this.currentRoute,
    required this.onNavbarTap,
  }) : super(key: key);

  BottomNavigationBarItem _buildNavigationItem(RouteData route) {
    return BottomNavigationBarItem(
      icon: Icon(route.icon),
      label: route.label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: routes.values.map((route) => _buildNavigationItem(route)).toList(),
      currentIndex: routes[currentRoute]!.navbarIdentifier,
      onTap: (int navbarIdentifier) => {
        onNavbarTap(routesInNavBar[navbarIdentifier]),
      },
    );
  }
}

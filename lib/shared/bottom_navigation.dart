import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/data/main_navigation.dart';
import 'package:atlast_mobile_app/routes.dart';

class BottomNavigation extends StatelessWidget {
  final ValueChanged<RouteEnum> onNavbarTap;

  const BottomNavigation({
    Key? key,
    required this.onNavbarTap,
  }) : super(key: key);

  Widget _buildNavigatorButton(RouteData route, bool active) {
    switch (route.key) {
      case RouteEnum.creator: // special button for "create"
        return Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 0.0),
                blurRadius: 4.0,
                spreadRadius: 1.0,
                color: AppColors.dark,
              ),
            ],
          ),
          child: Icon(route.icon, size: 50, color: AppColors.white),
        );
      default: // default button
        return Icon(
          route.icon,
          size: 30,
          color: active ? AppColors.primary : AppColors.dark,
        );
    }
  }

  BottomNavigationBarItem _buildNavigationItem(RouteData route) {
    return BottomNavigationBarItem(
      icon: _buildNavigatorButton(route, false),
      activeIcon: _buildNavigatorButton(route, true),
      label: route.label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainNavigationModel>(
      builder: (context, model, child) => Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.light,
              blurRadius: 20,
              spreadRadius: 15,
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: routesInNavBar.values
              .map((route) => _buildNavigationItem(route))
              .toList(),
          currentIndex: routes[model.currentRoute]!.navbarIdentifier!,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (int navbarIdentifier) => {
            onNavbarTap(routesInNavBarEnums[navbarIdentifier]),
          },
        ),
      ),
    );
  }
}

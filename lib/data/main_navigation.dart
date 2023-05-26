import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/routes.dart';

class MainNavigationStore extends ChangeNotifier {
  /// Private state
  RouteEnum _currRoute = RouteEnum.home;

  /// Getters
  RouteEnum get currentRoute => _currRoute;

  /// Setters
  void handleNav(RouteEnum newIdx) {
    _currRoute = newIdx;
    notifyListeners();
  }

  void resetNav() {
    _currRoute = RouteEnum.home;
    notifyListeners();
  }
}

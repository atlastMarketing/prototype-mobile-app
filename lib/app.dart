import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routes.dart';
import 'data/main_navigation.dart';
import 'data/user.dart';
import 'screens/_index.dart';
import 'shared/bottom_navigation.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _AppState createState() => _AppState();
}

final RouteObserver<ModalRoute<void>> rootObserver =
    RouteObserver<ModalRoute<void>>();

class _AppState extends State<App> with RouteAware {
  static final GlobalKey<NavigatorState> rootNavKey =
      GlobalKey<NavigatorState>();

  static final Map<RouteEnum, GlobalKey<NavigatorState>> _navkeys = {
    RouteEnum.home: GlobalKey<NavigatorState>(),
    RouteEnum.calendar: GlobalKey<NavigatorState>(),
    RouteEnum.creator: GlobalKey<NavigatorState>(),
    RouteEnum.analytics: GlobalKey<NavigatorState>(),
    RouteEnum.settings: GlobalKey<NavigatorState>(),
    RouteEnum.onboarding: GlobalKey<NavigatorState>(),
  };

  final PageController _pageController = PageController(initialPage: 0);

  void _navigateToPage(RouteEnum destination) {
    MainNavigationStore mainNavigationModelProvider =
        Provider.of<MainNavigationStore>(context, listen: false);
    RouteEnum currentRoute = mainNavigationModelProvider.currentRoute;

    if (currentRoute == destination) {
      // if trying to navigate to the current tab, pop to the first route
      if (_navkeys[currentRoute]!.currentState != null) {
        _navkeys[currentRoute]!
            .currentState!
            .popUntil((route) => route.isFirst);
      }
    } else if (destination == RouteEnum.creator) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Creator(navKey: _navkeys[RouteEnum.creator]!),
        ),
      );
    } else {
      // else, navigate to the new tab
      mainNavigationModelProvider.handleNav(destination);

      _pageController.animateToPage(
        routes[destination]!.stackOrder,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );

      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      // rootNavKey.currentState!.pushReplacementNamed(routes[destination]!.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Consumer<UserStore>(builder: (context, model, child) {
      print("user id: ${model.data.id}");
      print("model.isLoggedIn ${model.isLoggedIn}");
      print("model.isOnboarded ${model.isOnboarded}");
      return model.isOnboarded && model.isLoggedIn
          ? Scaffold(
              body: Navigator(
                observers: [rootObserver],
                key: rootNavKey,
                onGenerateRoute: (RouteSettings settings) {
                  return MaterialPageRoute(
                      settings: settings,
                      builder: (BuildContext context) => PageView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _pageController,
                            children: [
                              Home(
                                navKey: _navkeys[RouteEnum.home]!,
                                handleCreate: () =>
                                    _navigateToPage(RouteEnum.creator),
                              ),
                              Calendar(
                                navKey: _navkeys[RouteEnum.calendar]!,
                              ),
                              Analytics(
                                navKey: _navkeys[RouteEnum.analytics]!,
                              ),
                              Settings(
                                navKey: _navkeys[RouteEnum.settings]!,
                              ),
                            ],
                          ));
                },
              ),
              bottomNavigationBar: model.isOnboarded && model.isLoggedIn
                  ? BottomNavigation(onNavbarTap: _navigateToPage)
                  : null,
            )
          : Onboarding(
              navKey: _navkeys[RouteEnum.onboarding]!,
              navigateToPage: _navigateToPage,
            );
    });
  }
}

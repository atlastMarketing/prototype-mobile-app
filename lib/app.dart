import 'package:flutter/material.dart';

import 'routes.dart';
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
  RouteEnum _currentRoute = RouteEnum.home;

  static final GlobalKey<NavigatorState> rootNavKey =
      GlobalKey<NavigatorState>();

  static final Map<RouteEnum, GlobalKey<NavigatorState>> _navkeys = {
    RouteEnum.home: GlobalKey<NavigatorState>(),
    RouteEnum.calendar: GlobalKey<NavigatorState>(),
    RouteEnum.create: GlobalKey<NavigatorState>(),
    RouteEnum.analytics: GlobalKey<NavigatorState>(),
    RouteEnum.settings: GlobalKey<NavigatorState>(),
    RouteEnum.onboarding: GlobalKey<NavigatorState>(),
  };

  bool _isUserLoggedIn = false;
  bool _isUserOnboarded = false;
  // bool _isUserLoggedIn = true;
  // bool _isUserOnboarded = true;

  final PageController _pageController = PageController(initialPage: 0);

  void _handleSuccessfulLogin([bool isNewUser = false]) async {
    // TODO: Add real auth API calls
    // final user = await fetchSelfData();
    final bool isUserHasExistingData = true;

    // TODO: add smooth page transition
    setState(() => _isUserLoggedIn = true);
    if (isUserHasExistingData) _handleSuccessfulLogin();
  }

  void _handleSuccessfulOnboarding() async {
    setState(() {
      _isUserOnboarded = true;
      _isUserLoggedIn = true;
      _currentRoute = RouteEnum.home;
    });
    _navigateToPage(RouteEnum.home);
  }

  void _navigateToPage(RouteEnum destination) {
    if (_currentRoute == destination) {
      // if trying to navigate to the current tab, pop to the first route
      if (_navkeys[_currentRoute]!.currentState != null) {
        _navkeys[_currentRoute]!
            .currentState!
            .popUntil((route) => route.isFirst);
      }
    } else if (destination == RouteEnum.create) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Create(navKey: _navkeys[RouteEnum.create]!),
        ),
      );
    } else {
      // else, navigate to the new tab
      setState(() {
        _currentRoute = destination;
      });

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

    bool shouldShowOnboarding = !_isUserLoggedIn || !_isUserOnboarded;

    if (shouldShowOnboarding) {
      return Onboarding(
        navKey: _navkeys[RouteEnum.onboarding]!,
        isUserLoggedIn: _isUserLoggedIn,
        handleSuccessfulLogin: _handleSuccessfulLogin,
        handleSuccessfulOnboarding: _handleSuccessfulOnboarding,
      );
    }
    return Scaffold(
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
                        handleCreate: () => _navigateToPage(RouteEnum.create),
                      ),
                      Calendar(
                        navKey: _navkeys[RouteEnum.calendar]!,
                      ),
                      Analytics(
                        navKey: _navkeys[RouteEnum.analytics]!,
                      ),
                      Settings(
                          navKey: _navkeys[RouteEnum.settings]!,
                          resetOnboarding: () {
                            setState(() {
                              _isUserOnboarded = false;
                              _isUserLoggedIn = false;
                            });
                          }),
                    ],
                  ));
        },
      ),
      bottomNavigationBar: shouldShowOnboarding
          ? null
          : BottomNavigation(
              currentRoute: _currentRoute,
              onNavbarTap: _navigateToPage,
            ),
    );
  }
}

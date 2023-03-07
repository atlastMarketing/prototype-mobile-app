import 'package:flutter/material.dart';
import 'screens/_index.dart';
import 'shared/widgets/bottom_navigation.dart';
import 'routes.dart';

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

  final GlobalKey<NavigatorState> rootNavKey = GlobalKey<NavigatorState>();

  final Map<RouteEnum, GlobalKey<NavigatorState>> _navkeys = {
    RouteEnum.home: GlobalKey<NavigatorState>(),
    RouteEnum.calendar: GlobalKey<NavigatorState>(),
  };

  void _onNavbarTap(RouteEnum destination) {
    if (_currentRoute == destination) {
      // if trying to navigate to the current tab, pop to the first route
      _navkeys[_currentRoute]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      // else, navigate to the new tab
      setState(() {
        _currentRoute = destination;
      });

      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      rootNavKey.currentState!.pushReplacementNamed(routes[destination]!.route);
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

    return Scaffold(
      body: Navigator(
        observers: [rootObserver],
        key: rootNavKey,
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              if (settings.name == routes[RouteEnum.calendar]!.route) {
                return SamplePage(navKey: _navkeys[RouteEnum.calendar]!);
              } else {
                return Home(navKey: _navkeys[RouteEnum.home]!);
              }
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigation(
        currentRoute: _currentRoute,
        onNavbarTap: _onNavbarTap,
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/services/sample_service.dart';
import 'home_details.dart';
import 'home_landing.dart';

class Home extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;
  const Home({Key? key, required this.navKey}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String data;

  Future<void> _getData() async {
    SampleService serviceWorker = SampleService();
    await serviceWorker.getData();

    setState(() {
      data = 'results here';
    });
  }

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
              case '/details':
                return HomeDetails(
                  navKey: widget.navKey,
                );
              default:
                return HomeLanding(
                  navKey: widget.navKey,
                );
            }
          },
        );
      },
    );
  }
}

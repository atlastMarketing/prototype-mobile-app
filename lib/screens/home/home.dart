import 'package:flutter/material.dart';

import 'home_dashboard.dart';

class Home extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;
  final void Function() handleCreate;

  const Home({
    Key? key,
    required this.navKey,
    required this.handleCreate,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String data;

  Future<void> _getData() async {
    // SampleService serviceWorker = SampleService();
    // await serviceWorker.getData();

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
              default:
                return HomeDashboard(
                  navKey: widget.navKey,
                  handleCreate: widget.handleCreate,
                );
            }
          },
        );
      },
    );
  }
}

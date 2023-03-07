import 'package:flutter/material.dart';

class SamplePage extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;
  const SamplePage({Key? key, required this.navKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navKey,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            switch (settings.name) {
              default:
                return Scaffold(
                  appBar: AppBar(title: const Text('Sample Page')),
                  body: const Center(child: Text('lalalalalallaal')),
                  extendBody: false,
                );
            }
          },
        );
      },
    );
  }
}

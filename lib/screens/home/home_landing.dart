import 'package:flutter/material.dart';

class HomeLanding extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;

  const HomeLanding({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  void openDetailsPage() {
    navKey.currentState!.pushNamed('/details');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Landing'),
        centerTitle: false,
        toolbarHeight: 80,
      ),
      body: Center(
        child: Column(
          children: [
            const Text('You are on the home landing page'),
            TextButton(
              child: const Text('Go to details page'),
              onPressed: openDetailsPage,
            ),
          ],
        ),
      ),
      extendBody: false,
    );
  }
}

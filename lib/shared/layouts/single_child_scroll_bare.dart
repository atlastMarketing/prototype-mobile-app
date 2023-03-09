import 'package:flutter/material.dart';

class CustomScrollBehaviorEmpty extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class SingleChildScrollBare extends StatelessWidget {
  final Widget child;
  const SingleChildScrollBare({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
        behavior: CustomScrollBehaviorEmpty(),
        child: SingleChildScrollView(child: child));
  }
}

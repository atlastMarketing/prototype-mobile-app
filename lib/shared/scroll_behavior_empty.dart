import "package:flutter/material.dart";

class CustomScrollBehaviorEmpty extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

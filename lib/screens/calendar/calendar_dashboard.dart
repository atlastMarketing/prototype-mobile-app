import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/configs/layout.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';

class CalendarDashboard extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;

  const CalendarDashboard({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: pagePadding,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    HeroHeading(text: "Calendar Dashboard"),
                    Center(child: Text("TODO: make calendar and stuff")),
                  ],
                ),
              ),
            ],
          ),
        ),
        extendBody: false,
      ),
    );
  }
}

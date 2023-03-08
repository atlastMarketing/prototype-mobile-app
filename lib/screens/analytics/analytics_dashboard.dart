import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/configs/layout.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';

class AnalyticsDashboard extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;

  const AnalyticsDashboard({
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
                    HeroHeading(text: "Analytics Dashboard"),
                    Center(child: Text("TODO: make analytics and stuff")),
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

import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/configs/layout.dart';
import 'package:atlast_mobile_app/configs/theme.dart';
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
                  children: [
                    const HeroHeading(text: "Your Analytics"),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(100),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(padding: EdgeInsets.all(30)),
                            Image.asset("assets/images/maintenance.gif",
                                width: 150, height: 150),
                            const Padding(padding: EdgeInsets.all(10)),
                            const Text(
                              'This page is currently under construction. Come back later!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
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

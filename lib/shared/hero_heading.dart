import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/configs/theme.dart';

class HeroHeading extends StatelessWidget {
  final String text;
  final Color textColor;

  const HeroHeading({
    Key? key,
    required this.text,
    this.textColor = AppColors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Text(
        text,
        style: AppText.heading,
      ),
    );
  }
}

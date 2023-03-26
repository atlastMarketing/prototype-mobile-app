import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/configs/theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback handlePressed;
  final Color fillColor;
  final Color textColor;
  final bool disabled;

  const CustomButton({
    Key? key,
    required this.text,
    required this.handlePressed,
    this.fillColor = AppColors.primary,
    this.textColor = AppColors.white,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: disabled ? AppColors.light : fillColor,
        side: BorderSide(color: textColor),
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: disabled ? null : handlePressed,
      child: Text(
        text,
        style: disabled
            ? AppText.buttonText.merge(const TextStyle(color: AppColors.dark))
            : AppText.buttonText.merge(TextStyle(color: textColor)),
      ),
    );
  }
}

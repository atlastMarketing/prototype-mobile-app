import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/configs/theme.dart';

class CustomFormTextField extends StatelessWidget {
  final bool disabled;
  final String placeholderText;
  //x field options
  final TextEditingController? controller;
  final bool autocorrect;
  final bool enableSuggestions;
  final bool obscureText;
  final Color? fillColor;
  // additional (functional props)
  final String? Function(String?)? validator;

  const CustomFormTextField({
    Key? key,
    this.placeholderText = "",
    this.disabled = false,
    this.controller,
    this.validator,
    this.autocorrect = false,
    this.enableSuggestions = false,
    this.obscureText = false,
    this.fillColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: !disabled,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 15.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.light.withOpacity(0.5)),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.error),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.error),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        errorStyle: const TextStyle(color: AppColors.error),
        fillColor: fillColor ?? AppColors.white,
        filled: fillColor != null,
        hintText: placeholderText,
        errorMaxLines: 10,
      ),
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      obscureText: obscureText,
      validator: validator,
    );
  }
}

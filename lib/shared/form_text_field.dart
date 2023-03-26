import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/configs/theme.dart';

class CustomFormTextField extends StatelessWidget {
  final bool disabled;
  final bool previewOnly;
  final String placeholderText;
  //x field options
  final TextEditingController? controller;
  final bool autocorrect;
  final bool enableSuggestions;
  final bool obscureText;
  final Color? fillColor;
  // additional (functional props)
  final String? Function(String?)? validator;
  final int vSize;
  final TextInputType keyboardType;

  const CustomFormTextField({
    Key? key,
    this.disabled = false,
    this.previewOnly = false,
    this.placeholderText = "",
    this.controller,
    this.autocorrect = false,
    this.enableSuggestions = false,
    this.obscureText = false,
    this.fillColor,
    this.validator,
    this.vSize = 1,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: !disabled && !previewOnly,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: previewOnly
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 15.0,
              ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.dark.withOpacity(0.5)),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        disabledBorder: previewOnly
            ? InputBorder.none
            : const OutlineInputBorder(
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
      minLines: vSize,
      maxLines: vSize,
      keyboardType: keyboardType,
    );
  }
}

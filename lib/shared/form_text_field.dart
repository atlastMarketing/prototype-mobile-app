import 'package:atlast_mobile_app/shared/form_validator.dart';
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
  final FocusNode? focusNode;

  CustomFormTextField({
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
    this.focusNode,
  }) : super(key: key);

  final backupFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode ?? backupFocusNode,
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
      validator: validator != null
          ? CustomFormValidator(
              validator: validator!,
              focusNode: focusNode ?? backupFocusNode,
            )
          : null,
      minLines: vSize,
      maxLines: vSize,
      keyboardType: keyboardType,
    );
  }
}

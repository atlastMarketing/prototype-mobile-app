import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/configs/theme.dart';

class CustomFormDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) setDate;
  // date params
  final bool disabled;
  final String placeholderText;

  const CustomFormDatePicker({
    Key? key,
    required this.controller,
    required this.setDate,
    this.disabled = false,
    this.placeholderText = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: !disabled,
      readOnly: true,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 15.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.dark.withOpacity(0.5)),
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
        hintText: placeholderText,
        errorMaxLines: 10,
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );

        if (pickedDate != null) {
          setDate("2022-05-08");
        }
      },
    );
  }
}

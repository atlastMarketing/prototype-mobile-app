import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/configs/theme.dart';

class CustomFormTextDropdown extends StatelessWidget {
  final String value;
  final void Function(dynamic) handleChanged;
  final List<String> items;
  final Color? fillColor;

  const CustomFormTextDropdown({
    Key? key,
    required this.value,
    required this.handleChanged,
    required this.items,
    this.fillColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonFormField(
        menuMaxHeight: 500,
        value: value,
        onChanged: handleChanged,
        isExpanded: true,
        borderRadius: BorderRadius.circular(10),
        focusColor: AppColors.primary,
        elevation: 8,
        items: items
            .map((i) => DropdownMenuItem(value: i, child: Text(i)))
            .toList(),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8.0,
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
          errorStyle: const TextStyle(color: AppColors.error),
          fillColor: fillColor ?? AppColors.white,
          filled: fillColor != null,
          errorMaxLines: 10,
        ),
      ),
    );
  }
}

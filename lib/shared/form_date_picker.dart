import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:atlast_mobile_app/configs/theme.dart';

class CustomFormDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final void Function(DateTime, String) setDate;
  // date params
  final bool disabled;
  final String placeholderText;
  final DateTime? currDate;
  final DateTime? startDate;
  final DateTime? endDate;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;

  const CustomFormDatePicker({
    Key? key,
    required this.controller,
    required this.setDate,
    this.disabled = false,
    this.placeholderText = "",
    this.currDate,
    this.startDate,
    this.endDate,
    this.focusNode,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: !disabled,
      readOnly: true,
      controller: controller,
      focusNode: focusNode,
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
          initialDate: currDate ?? startDate ?? DateTime.now(),
          currentDate: currDate,
          firstDate: startDate ?? DateTime.now(),
          lastDate: endDate ?? DateTime(2101),
        );

        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          setDate(pickedDate, formattedDate);
        }
      },
      validator: validator,
    );
  }
}

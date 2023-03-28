import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/configs/theme.dart';

class CustomFormMultiDatePicker extends StatelessWidget {
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final void Function(DateTimeRange) setDate;
  // date params
  final bool disabled;
  final String placeholderText;
  final DateTimeRange? currDateRange;
  final DateTime? startDate;
  final DateTime? endDate;
  final FocusNode? focusNode;

  const CustomFormMultiDatePicker({
    Key? key,
    required this.startDateController,
    required this.endDateController,
    required this.setDate,
    this.disabled = false,
    this.placeholderText = "",
    this.currDateRange,
    this.startDate,
    this.endDate,
    this.focusNode,
  }) : super(key: key);

  void _handleTap(BuildContext context) async {
    DateTime currDate = DateTime.now();
    if (currDateRange != null) {
      currDate = currDateRange!.start;
    }
    DateTimeRange? pickedDateRange = await showDateRangePicker(
      context: context,
      currentDate: currDate,
      firstDate: startDate ?? DateTime.now(),
      lastDate: endDate ?? DateTime(2101),
    );

    if (pickedDateRange != null) {
      setDate(pickedDateRange);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: TextFormField(
            enabled: !disabled,
            readOnly: true,
            controller: startDateController,
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
            onTap: () => _handleTap(context),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(height: 1, width: 15, color: AppColors.black),
        ),
        Flexible(
          child: TextFormField(
            enabled: !disabled,
            readOnly: true,
            controller: endDateController,
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
            onTap: () => _handleTap(context),
          ),
        ),
      ],
    );
  }
}

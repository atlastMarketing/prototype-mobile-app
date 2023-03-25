import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:flutter/material.dart';

class SmartAutofillText extends StatelessWidget {
  const SmartAutofillText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.auto_awesome, size: 10, color: AppColors.primary),
        const Padding(padding: EdgeInsets.only(right: 5)),
        Text(
          "Auto-filled using Atlast smart suggestions",
          style: AppText.bodySemiBold
              .merge(AppText.primaryText)
              .merge(AppText.bodySmall),
        ),
      ],
    );
  }
}

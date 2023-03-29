import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:flutter/material.dart';

class WidgetOverlays extends StatelessWidget {
  final bool disabled;
  final bool loading;
  final Widget child;
  final String? errorText;
  const WidgetOverlays({
    Key? key,
    this.disabled = false,
    this.loading = false,
    required this.child,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(
        disabled
            ? [
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
              ]
            : [
                1,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
              ],
      ),
      child: Stack(
        children: [
          child,
          if (loading)
            Container(
              color: AppColors.dark.withOpacity(0.2),
              child: const Center(child: CircularProgressIndicator()),
            ),
          if (errorText != null)
            Container(
              padding: const EdgeInsets.all(50),
              color: AppColors.dark.withOpacity(0.5),
              child: Center(
                child: Text(
                  errorText!,
                  style: AppText.primaryText.merge(AppText.subheading),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

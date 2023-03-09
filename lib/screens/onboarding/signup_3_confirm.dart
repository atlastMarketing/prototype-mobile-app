import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/configs/theme.dart';

import 'package:atlast_mobile_app/shared/animated_check.dart';
import 'package:atlast_mobile_app/shared/animated_loading_dots.dart';
import 'package:atlast_mobile_app/shared/animated_text_blinking.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';

class OnboardingConfirm extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;
  final void Function() handleSuccessfulOnboarding;

  const OnboardingConfirm({
    Key? key,
    required this.navKey,
    required this.handleSuccessfulOnboarding,
  }) : super(key: key);

  @override
  _OnboardingConfirmState createState() => _OnboardingConfirmState();
}

class _OnboardingConfirmState extends State<OnboardingConfirm> {
  int _animationState = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _animationState = 1);
    });
    Future.delayed(const Duration(milliseconds: 5500), () {
      setState(() => _animationState = 2);
    });
    Future.delayed(const Duration(milliseconds: 8000), () {
      widget.handleSuccessfulOnboarding();
    });
  }

  Widget? _buildAnimationWidget() {
    switch (_animationState) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AnimatedLoadingDots(size: 75),
            AnimatedBlinkText(
              text: "Curating the Application Based on Your Business",
              textStyle: AppText.bodyBold
                  .merge(const TextStyle(color: AppColors.primary)),
              width: 200,
              duration: 800,
            )
          ],
        );
      case 2:
        return const AnimatedCheck();
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutFullPage(
      content: Center(child: _buildAnimationWidget()),
    );
  }
}

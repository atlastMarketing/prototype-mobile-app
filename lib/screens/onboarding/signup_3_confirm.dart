import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/data/user.dart';
import 'package:atlast_mobile_app/shared/animated_check.dart';
import 'package:atlast_mobile_app/shared/animated_loading_dots.dart';
import 'package:atlast_mobile_app/shared/animated_text_blinking.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';

class OnboardingConfirm extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;

  const OnboardingConfirm({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  @override
  _OnboardingConfirmState createState() => _OnboardingConfirmState();
}

class _OnboardingConfirmState extends State<OnboardingConfirm> {
  int _animationState = 0;

  @override
  void initState() {
    super.initState();

    UserStore userModelProvider =
        Provider.of<UserStore>(context, listen: false);
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _animationState = 1);
    });
    Future.delayed(const Duration(milliseconds: 5500), () {
      setState(() => _animationState = 2);
    });
    Future.delayed(const Duration(milliseconds: 8000), () {
      userModelProvider.setIsOnboarded(true);
      if (!userModelProvider.isLoggedIn) {
        userModelProvider.login("DEFAULT_USER_ID");
      }
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

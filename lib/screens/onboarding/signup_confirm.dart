import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:atlast_mobile_app/constants/social_media_platforms.dart';
import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/data/suggested_posts.dart';
import 'package:atlast_mobile_app/data/user.dart';
import 'package:atlast_mobile_app/models/content_model.dart';
import 'package:atlast_mobile_app/services/generator_service.dart';
import 'package:atlast_mobile_app/services/user_service.dart';
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
  bool _isError = false;

  Future<void> _fetchSuggestions() async {
    try {
      UserStore userModelProvider =
          Provider.of<UserStore>(context, listen: false);
      SuggestedPostsStore suggestedPostProvider =
          Provider.of<SuggestedPostsStore>(context, listen: false);

      final List<List<PostDraft>> response =
          await GeneratorService.fetchSuggestions(
        // TODO: get the connected social media paltforms
        platform: SocialMediaPlatforms.instagram,
        userData: userModelProvider.data,
      );

      suggestedPostProvider.addCollections(response);
      return;
    } catch (err) {
      print(err);
      return;
    }
  }

  void _doTheWork() async {
    UserStore userModelProvider =
        Provider.of<UserStore>(context, listen: false);

    // Future.delayed(const Duration(milliseconds: 8000), () {});
    // if already logged in, just save data
    if (userModelProvider.isLoggedIn) {
      bool success = await UserService.updateAccount(userModelProvider.data);
      if (!success) {
        setState(() => _isError = true);
        return;
      }
      setState(() => _animationState = 2);

      Future.delayed(const Duration(milliseconds: 3000), () {
        userModelProvider.setIsOnboarded(true);
      });
    }
    // if creating new account
    else {
      setState(() => _animationState = 1);
      String id = await UserService.createAccount(userModelProvider.data);
      if (id == "") {
        setState(() => _isError = true);
        return;
      }
      userModelProvider.save(id);
      await _fetchSuggestions();

      Future.delayed(const Duration(milliseconds: 5000), () {
        setState(() => _animationState = 2);
      });

      Future.delayed(const Duration(milliseconds: 8000), () {
        userModelProvider.setIsOnboarded(true);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _doTheWork();
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
      content: _isError
          ? const Center(
              child: Text(
                "An error occurred during account creation!",
                style: AppText.subheading,
              ),
            )
          : Center(child: _buildAnimationWidget()),
    );
  }
}

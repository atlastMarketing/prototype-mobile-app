import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/data/scheduled_posts.dart';
import 'package:atlast_mobile_app/models/content_model.dart';
import 'package:atlast_mobile_app/shared/animated_check.dart';
import 'package:atlast_mobile_app/shared/animated_loading_dots.dart';
import 'package:atlast_mobile_app/shared/animated_text_blinking.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';

class CreatorCampaignConfirm extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;
  final List<PostContent> draftPosts;

  const CreatorCampaignConfirm({
    Key? key,
    required this.navKey,
    required this.draftPosts,
  }) : super(key: key);

  @override
  _CreatorCampaignConfirmState createState() => _CreatorCampaignConfirmState();
}

class _CreatorCampaignConfirmState extends State<CreatorCampaignConfirm> {
  int _animationState = 0;

  void _doTheWork() async {
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   setState(() => _animationState = 1);
    // });

    // setState(() => _animationState = 1);
    Provider.of<ScheduledPostsStore>(context, listen: false)
        .add(widget.draftPosts);
    // setState(() => _animationState = 2);

    // Future.delayed(const Duration(milliseconds: 5500), () {
    //   setState(() => _animationState = 2);
    // });
    Future.delayed(const Duration(milliseconds: 5000), () {
      widget.navKey.currentState!.popUntil((Route r) => r.isFirst);
    });
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
              text: "Saving your campaign",
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

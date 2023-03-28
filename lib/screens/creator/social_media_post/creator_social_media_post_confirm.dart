import 'package:atlast_mobile_app/data/user.dart';
import 'package:atlast_mobile_app/services/content_manager_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/data/scheduled_posts.dart';
import 'package:atlast_mobile_app/models/content_model.dart';
import 'package:atlast_mobile_app/shared/animated_check.dart';
import 'package:atlast_mobile_app/shared/animated_loading_dots.dart';
import 'package:atlast_mobile_app/shared/animated_text_blinking.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';

class CreatorSocialMediaPostConfirm extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;
  final List<PostContent> draftPosts;

  const CreatorSocialMediaPostConfirm({
    Key? key,
    required this.navKey,
    required this.draftPosts,
  }) : super(key: key);

  @override
  _CreatorSocialMediaPostConfirmState createState() =>
      _CreatorSocialMediaPostConfirmState();
}

class _CreatorSocialMediaPostConfirmState
    extends State<CreatorSocialMediaPostConfirm> {
  int _animationState = 0;

  void _doTheWork() async {
    ScheduledPostsStore scheduledPostsStore =
        Provider.of<ScheduledPostsStore>(context, listen: false);
    UserStore userStore = Provider.of<UserStore>(context, listen: false);
    setState(() => _animationState = 1);

    List<PostContent> newPosts = [];

    try {
      newPosts = await Future.wait(widget.draftPosts.map(
        (PostContent draft) async {
          String? id = await ContentManagerService.saveContent(
            draft.toDraft(),
            userStore.data,
          );
          if (id == null) throw Error();
          draft.id = id;
          return draft;
        },
      ));
    } catch (err) {
      print("FAILED TO SAVE DRAFT POSTS: $err");
      widget.navKey.currentState!.pop();
      return;
    }

    scheduledPostsStore.add(newPosts);

    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() => _animationState = 2);
    });
    Future.delayed(const Duration(milliseconds: 6000), () {
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
              text: "Saving your post",
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

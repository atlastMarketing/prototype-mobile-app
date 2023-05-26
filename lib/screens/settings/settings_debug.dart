import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/constants/social_media_platforms.dart';
import 'package:atlast_mobile_app/constants/stock_images.dart';
import 'package:atlast_mobile_app/data/scheduled_posts.dart';
import 'package:atlast_mobile_app/data/suggested_posts.dart';
import 'package:atlast_mobile_app/data/user.dart';
import 'package:atlast_mobile_app/models/content_model.dart';
import 'package:atlast_mobile_app/services/content_manager_service.dart';
import 'package:atlast_mobile_app/services/generator_service.dart';
import 'package:atlast_mobile_app/shared/layouts/normal_page.dart';

class SettingsDebug extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;

  const SettingsDebug({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  void _handleBack() {
    navKey.currentState!.pop();
  }

  void _resetOnboarding(BuildContext ctx) {
    Provider.of<UserStore>(ctx, listen: false).setIsOnboarded(false);
  }

  void _triggerHelpPopups(BuildContext ctx) {
    bool currState = Provider.of<UserStore>(ctx, listen: false).hasHelpPopups;
    Provider.of<UserStore>(ctx, listen: false).setHasHelpPopups(!currState);
  }

  Future<void> _fetchSuggestions(BuildContext ctx) async {
    try {
      UserStore userModelProvider = Provider.of<UserStore>(ctx, listen: false);
      SuggestedPostsStore suggestedPostProvider =
          Provider.of<SuggestedPostsStore>(ctx, listen: false);

      final List<PostDraft> response = await GeneratorService.fetchSuggestions(
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

  Future<void> _fetchScheduledPosts(BuildContext ctx) async {
    try {
      UserStore userModelProvider = Provider.of<UserStore>(ctx, listen: false);
      ScheduledPostsStore scheduledPostsProvider =
          Provider.of<ScheduledPostsStore>(ctx, listen: false);

      final List<PostContent> response =
          await ContentManagerService.getAllContent(
        userModelProvider.data.id,
      );

      scheduledPostsProvider.add(response);
      return;
    } catch (err) {
      print(err);
      return;
    }
  }

  void _createSampleSuggestions(BuildContext ctx) {
    SuggestedPostsStore suggestedPostsProvider =
        Provider.of<SuggestedPostsStore>(ctx, listen: false);

    List<PostDraft> generated = [];
    for (int idx in List<int>.generate(5, (i) => i)) {
      DateTime today = DateTime.now().add(Duration(days: idx));
      generated.add(PostDraft(
        platform: SocialMediaPlatforms.instagram,
        dateTime: today.millisecondsSinceEpoch,
        caption:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis at tellus at urna condimentum mattis pellentesque id.",
        imageUrl: STOCK_IMAGES[idx],
      ));
    }
    suggestedPostsProvider.addCollections(generated);
  }

  void _createSampleCampaign(BuildContext ctx) {
    ScheduledPostsStore scheduledPostsProvider =
        Provider.of<ScheduledPostsStore>(ctx, listen: false);

    final Random randomizer = Random();
    DateTime today = DateTime.now().add(Duration(
      hours: randomizer.nextInt(6),
    ));

    List<PostContent> generated = [];

    generated.add(PostContent(
      id: "sample-generated-ig-first",
      platform: SocialMediaPlatforms.instagram,
      dateTime: today.millisecondsSinceEpoch,
      caption:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis at tellus at urna condimentum mattis pellentesque id.",
      imageUrl: STOCK_IMAGES[randomizer.nextInt(STOCK_IMAGES.length)],
    ));
    generated.add(PostContent(
      id: "sample-generated-fb-first",
      platform: SocialMediaPlatforms.facebook,
      dateTime: today.millisecondsSinceEpoch,
      caption:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis at tellus at urna condimentum mattis pellentesque id.",
      imageUrl: STOCK_IMAGES[randomizer.nextInt(STOCK_IMAGES.length)],
    ));

    for (int idx in List<int>.generate(5, (i) => i)) {
      DateTime today = DateTime.now().add(Duration(
        days: idx + 1,
        hours: randomizer.nextInt(6),
      ));
      generated.add(PostContent(
        id: "sample-generated-ig-$idx",
        platform: SocialMediaPlatforms.instagram,
        dateTime: today.millisecondsSinceEpoch,
        caption:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis at tellus at urna condimentum mattis pellentesque id.",
        imageUrl: STOCK_IMAGES[randomizer.nextInt(STOCK_IMAGES.length)],
      ));
    }
    for (int idx in List<int>.generate(3, (i) => i)) {
      DateTime today = DateTime.now().add(Duration(
        days: idx * 2 + 1,
        hours: randomizer.nextInt(6),
      ));
      generated.add(PostContent(
        id: "sample-generated-fb-$idx",
        platform: SocialMediaPlatforms.facebook,
        dateTime: today.millisecondsSinceEpoch,
        caption:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis at tellus at urna condimentum mattis pellentesque id.",
        imageUrl: STOCK_IMAGES[randomizer.nextInt(STOCK_IMAGES.length)],
      ));
    }
    scheduledPostsProvider.add(generated);
  }

  void _clearSuggestedPosts(BuildContext ctx) {
    ScheduledPostsStore scheduledPostsProvider =
        Provider.of<ScheduledPostsStore>(ctx, listen: false);
    scheduledPostsProvider.removeAll();
  }

  void _clearScheduledPosts(BuildContext ctx) {
    ScheduledPostsStore scheduledPostsProvider =
        Provider.of<ScheduledPostsStore>(ctx, listen: false);
    scheduledPostsProvider.removeAll();
  }

  @override
  Widget build(BuildContext context) {
    bool popupsStatus =
        Provider.of<UserStore>(context, listen: false).hasHelpPopups;

    return LayoutNormalPage(
      handleBack: _handleBack,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "Utility Functions for DEBUG:",
            style: AppText.bodyBold,
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          FilledButton(
            onPressed: () => _triggerHelpPopups(context),
            child: popupsStatus
                ? const Text("Deactivate Popups")
                : const Text("Activate Popups"),
          ),
          const Divider(),
          FilledButton(
            onPressed: () => _fetchSuggestions(context),
            child: const Text("Fetch suggestions (online)"),
          ),
          FilledButton(
            onPressed: () => _fetchScheduledPosts(context),
            child: const Text("Fetch scheduled posts (online)"),
          ),
          FilledButton(
            onPressed: () => _createSampleSuggestions(context),
            child: const Text("Create sample suggestions (offline)"),
          ),
          FilledButton(
            onPressed: () => _createSampleCampaign(context),
            child: const Text("Create sample campaign (offline)"),
          ),
          const Divider(),
          FilledButton(
            onPressed: () => _clearSuggestedPosts(context),
            child: const Text("Clear all suggested posts"),
          ),
          FilledButton(
            onPressed: () => _clearScheduledPosts(context),
            child: const Text("Clear all scheduled posts"),
          ),
          FilledButton(
            onPressed: () => _resetOnboarding(context),
            child: const Text("Reset Onboarding"),
          ),
        ],
      ),
    );
  }
}

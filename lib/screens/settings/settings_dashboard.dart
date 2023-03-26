import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:atlast_mobile_app/configs/layout.dart';
import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/constants/social_media_platforms.dart';
import 'package:atlast_mobile_app/constants/stock_images.dart';
import 'package:atlast_mobile_app/data/scheduled_posts.dart';
import 'package:atlast_mobile_app/data/suggested_posts.dart';
import 'package:atlast_mobile_app/data/user.dart';
import 'package:atlast_mobile_app/models/content_model.dart';
import 'package:atlast_mobile_app/services/generator_service.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';

class SettingsDashboard extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;

  const SettingsDashboard({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  void _resetOnboarding(BuildContext ctx) {
    Provider.of<UserStore>(ctx, listen: false).setIsOnboarded(false);
  }

  void _logout(BuildContext ctx) {
    Provider.of<UserStore>(ctx, listen: false).clear();
    Provider.of<UserStore>(ctx, listen: false).setIsOnboarded(false);
    Provider.of<UserStore>(ctx, listen: false).setHasHelpPopups(true);
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
        imageUrl: stockImages[idx],
      ));
    }
    suggestedPostsProvider.addCollections(generated);
  }

  void _createSampleCampaign(BuildContext ctx) {
    ScheduledPostsStore scheduledPostsProvider =
        Provider.of<ScheduledPostsStore>(ctx, listen: false);

    List<PostContent> generated = [];
    for (int idx in List<int>.generate(5, (i) => i)) {
      DateTime today = DateTime.now().add(Duration(days: idx));
      generated.add(PostContent(
        id: "sample-generated-$idx",
        platform: SocialMediaPlatforms.instagram,
        dateTime: today.millisecondsSinceEpoch,
        caption:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis at tellus at urna condimentum mattis pellentesque id.",
        imageUrl: stockImages[stockImages.length - 1 - idx],
      ));
    }
    scheduledPostsProvider.add(generated);
  }

  @override
  Widget build(BuildContext context) {
    bool popupsStatus =
        Provider.of<UserStore>(context, listen: false).hasHelpPopups;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: pagePadding,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const HeroHeading(text: "Settings Dashboard"),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Utility Functions for DEBUG:",
                            style: AppText.bodyBold,
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5)),
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
                            onPressed: () => _createSampleSuggestions(context),
                            child: const Text(
                                "Create sample suggestions (offline)"),
                          ),
                          FilledButton(
                            onPressed: () => _createSampleCampaign(context),
                            child:
                                const Text("Create sample campaign (offline)"),
                          ),
                          const Divider(),
                          FilledButton(
                            onPressed: () => _resetOnboarding(context),
                            child: const Text("Reset Onboarding"),
                          ),
                          FilledButton(
                            onPressed: () => _logout(context),
                            child: const Text("Logout"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        extendBody: false,
      ),
    );
  }
}

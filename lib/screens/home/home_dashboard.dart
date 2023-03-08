import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/configs/layout.dart';
import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/constants/suggested_posts.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/shared/post_preview.dart';

class HomeDashboard extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;
  final void Function() handleCreate;

  const HomeDashboard({
    Key? key,
    required this.navKey,
    required this.handleCreate,
  }) : super(key: key);

  Widget _buildSuggestedPosts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Today's Suggested Posts", style: AppText.subheading),
        const Padding(padding: EdgeInsets.only(bottom: 8)),
        Row(
          children: [
            const Icon(Icons.auto_awesome, size: 10, color: AppColors.primary),
            const Padding(padding: EdgeInsets.only(right: 5)),
            Text(
              "Generated using Atlast smart suggestions",
              style: AppText.bodySemiBold
                  .merge(AppText.primaryText)
                  .merge(AppText.bodySmall),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(bottom: 20)),
        Column(
          children: [
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: suggestedPosts.length,
                itemBuilder: (context, idx) => PostPreview(
                  imageUrl: suggestedPosts[idx]["imageUrl"],
                  size: 120,
                  handlePressed: () {},
                ),
                separatorBuilder: (context, idx) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildUpcomingPosts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
          ),
          onPressed: () {},
          child: Row(
            children: [
              Text(
                "Upcoming Posts",
                style: AppText.subheading.merge(AppText.blackText),
              ),
              const Icon(Icons.chevron_right, color: AppColors.black),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 8)),
        Material(
          elevation: 1,
          child: Container(
            height: 100,
            width: double.infinity,
            color: AppColors.dark.withOpacity(0.1),
            child: const Center(
              child: Text("There's nothing scheduled!"),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    const HeroHeading(text: "Dashboard"),
                    _buildSuggestedPosts(),
                    const Padding(padding: EdgeInsets.only(bottom: 40)),
                    _buildUpcomingPosts(),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Create',
                  handlePressed: handleCreate,
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/constants/suggested_posts.dart';
import 'package:atlast_mobile_app/data/scheduled_posts.dart';
import 'package:atlast_mobile_app/shared/avatar_image.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/shared/post_preview.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';
import 'package:atlast_mobile_app/shared/layouts/single_child_scroll_bare.dart';

class HomeDashboard extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;
  final void Function() handleCreate;

  const HomeDashboard({
    Key? key,
    required this.navKey,
    required this.handleCreate,
  }) : super(key: key);

  void _openSuggestedPost(String postId) {
    print("Opening suggested post with id $postId");
  }

  void _openUpcomingPost(String postId) {
    print("Opening upcoming post with id $postId");
  }

  Widget _buildSuggestedPosts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Today's Suggested Posts", style: AppText.subheading),
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
                  handlePressed: () =>
                      _openSuggestedPost(suggestedPosts[idx]["id"]),
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
    return Consumer<ScheduledPostsStore>(
      builder: (context, model, child) => Column(
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
          model.somePosts.isNotEmpty
              ? Column(
                  children: model.somePosts.map((post) {
                    DateTime? dt = post.dateTime != null
                        ? DateTime.fromMillisecondsSinceEpoch(post.dateTime!)
                        : null;
                    String dtStrMonth = dt != null
                        ? DateFormat.MMM().format(dt).toUpperCase()
                        : "??";
                    String dtStrDate =
                        dt != null ? DateFormat.d().format(dt) : "??";

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SizedBox(
                        height: 110,
                        width: double.infinity,
                        child: Material(
                          color: AppColors.light,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () => _openUpcomingPost(post.id),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 15,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        dtStrMonth,
                                        style: AppText.bodySemiBold,
                                      ),
                                      Text(
                                        dtStrDate,
                                        style: AppText.heading,
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(right: 15)),
                                  Container(
                                    decoration: const BoxDecoration(
                                        color: AppColors.black),
                                    height: 100,
                                    width: 1,
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(right: 15)),
                                  Flexible(
                                    child: Text(
                                      post.caption ?? "No caption yet!",
                                      style: post.caption != null
                                          ? AppText.bodySmall
                                          : AppText.bodySmall
                                              .merge(AppText.primaryText),
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(right: 20)),
                                  AvatarImage(
                                    post.imageUrl ?? "",
                                    width: 60,
                                    height: 60,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )
              : Material(
                  elevation: 1,
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    color: AppColors.dark.withOpacity(0.1),
                    child: const Center(
                      child: Text(
                        "There's nothing scheduled!",
                        style: AppText.bodySmall,
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutFullPage(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeroHeading(text: "Dashboard"),
          Expanded(
            child: SingleChildScrollBare(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildSuggestedPosts(),
                  const Padding(padding: EdgeInsets.only(bottom: 20)),
                  _buildUpcomingPosts(),
                ],
              ),
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
    );
  }
}

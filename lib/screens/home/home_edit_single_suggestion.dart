import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:atlast_mobile_app/configs/layout.dart';
import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/constants/social_media_platforms.dart';
import 'package:atlast_mobile_app/data/scheduled_posts.dart';
import 'package:atlast_mobile_app/data/suggested_posts.dart';
import 'package:atlast_mobile_app/models/content_model.dart';
import 'package:atlast_mobile_app/shared/animated_loading_dots.dart';
import 'package:atlast_mobile_app/shared/animated_text_blinking.dart';
import 'package:atlast_mobile_app/shared/avatar_image.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/form_text_field.dart';
import 'package:atlast_mobile_app/shared/layouts/single_child_scroll_bare.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';

class HomeEditSingleSuggestion extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;
  final int suggestionId;

  const HomeEditSingleSuggestion({
    Key? key,
    required this.navKey,
    required this.suggestionId,
  }) : super(key: key);

  @override
  _HomeEditSingleSuggestionState createState() =>
      _HomeEditSingleSuggestionState();
}

class _HomeEditSingleSuggestionState extends State<HomeEditSingleSuggestion> {
  final TextEditingController _captionController = TextEditingController();

  bool _isPostLoaded = false;
  bool _isPostNotFound = false;
  late PostDraft _postData;

  void _handleBack() {
    widget.navKey.currentState!.pop();
  }

  void _loadPostData() async {
    List<PostDraft> posts =
        Provider.of<SuggestedPostsStore>(context, listen: false).suggestions;

    if (widget.suggestionId > posts.length || widget.suggestionId < 0) {
      setState(() {
        _isPostLoaded = true;
        _isPostNotFound = true;
      });
      return;
    }

    PostDraft post = posts[widget.suggestionId];
    _captionController.text = post.caption ?? "";
    setState(() {
      _isPostLoaded = true;
      _postData = post;
    });
  }

  void _handleCreate() {
    SuggestedPostsStore suggestedPostsStore =
        Provider.of<SuggestedPostsStore>(context, listen: false);
    ScheduledPostsStore scheduledPostsStore =
        Provider.of<ScheduledPostsStore>(context, listen: false);
    scheduledPostsStore.add([
      PostContent(
        id: "suggested-turned-scheduled-${widget.suggestionId}",
        platform: _postData.platform,
        dateTime: _postData.dateTime!,
        caption: _postData.caption!.trim(),
        imageUrl: _postData.imageUrl!,
      )
    ]);
    suggestedPostsStore.pop();
    _handleBack();
  }

  @override
  void initState() {
    super.initState();
    _loadPostData();
  }

  Widget _buildImageUploader() {
    return _postData.imageUrl != null
        ? AvatarImage(Uri.encodeFull(_postData.imageUrl!))
        : Stack(
            children: [
              Image.asset("assets/images/default_placeholder.png"),
              Positioned.fill(
                child: Material(
                  color: AppColors.black.withOpacity(0.2),
                  child: InkWell(
                    onTap: () {},
                    child: const Center(child: Icon(Icons.add, size: 60)),
                  ),
                ),
              )
            ],
          );
  }

  Widget _buildForm() {
    if (!_isPostLoaded) {
      return Center(
        child: Column(
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
        ),
      );
    }

    if (_isPostNotFound) {
      return Center(
        child: Text(
          "Post not found.",
          style:
              AppText.heading.merge(const TextStyle(color: AppColors.primary)),
        ),
      );
    }

    DateTime dt = DateTime.fromMillisecondsSinceEpoch(_postData.dateTime!);
    String dtStrMonth = DateFormat.MMM().format(dt).toUpperCase();
    String dtStrDate = DateFormat.d().format(dt);

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 3),
                blurRadius: 2,
                spreadRadius: 2,
                color: Colors.black26,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildImageUploader(),
              ),
              CustomFormTextField(
                controller: _captionController,
                previewOnly: true,
                autocorrect: true,
                vSize: 7,
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 30,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
              color: AppColors.secondary,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 2),
                  blurRadius: 1,
                  spreadRadius: 1,
                  color: Colors.black26,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dtStrMonth,
                  style: AppText.bodySemiBold.merge(AppText.whiteText),
                ),
                Text(
                  dtStrDate,
                  style: AppText.heading.merge(AppText.whiteText),
                ),
              ],
            ),
          ),
        ),
        // TODO: replace with platform icons
        Positioned(
          top: 30,
          left: 120,
          child: Text(
            socialMediaPlatformsOptions[_postData.platform]!,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutFullPage(
      handleBack: _handleBack,
      paddingOverwrite: EdgeInsets.zero,
      content: Column(
        children: [
          Container(
            width: double.infinity,
            padding: pagePadding,
            clipBehavior: Clip.none,
            child: _buildForm(),
          ),
          Container(
            padding: pageHorizontalPadding,
            child: SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Create Scheduled Post',
                handlePressed: _handleCreate,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

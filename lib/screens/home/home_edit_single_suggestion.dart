import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:atlast_mobile_app/configs/layout.dart';
import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/constants/social_media_platforms.dart';
import 'package:atlast_mobile_app/data/scheduled_posts.dart';
import 'package:atlast_mobile_app/data/suggested_posts.dart';
import 'package:atlast_mobile_app/data/user.dart';
import 'package:atlast_mobile_app/models/content_model.dart';
import 'package:atlast_mobile_app/services/content_manager_service.dart';
import 'package:atlast_mobile_app/shared/animated_loading_dots.dart';
import 'package:atlast_mobile_app/shared/animated_text_blinking.dart';
import 'package:atlast_mobile_app/shared/avatar_image.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/form_text_field.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';
import 'package:atlast_mobile_app/shared/layouts/single_child_scroll_bare.dart';

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
  bool _isPostSaving = false;

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

  Future<void> _handleCreate() async {
    SuggestedPostsStore suggestedPostsStore =
        Provider.of<SuggestedPostsStore>(context, listen: false);
    ScheduledPostsStore scheduledPostsStore =
        Provider.of<ScheduledPostsStore>(context, listen: false);
    UserStore userStore = Provider.of<UserStore>(context, listen: false);

    setState(() => _isPostSaving = true);

    String? id =
        await ContentManagerService.saveContent(_postData, userStore.data);

    // if (id == null) {
    // setState(() => _isPostSaving = false);
    // return;
    // }
    id ??= "suggested-turned-scheduled-${widget.suggestionId}";

    scheduledPostsStore.add([
      PostContent(
        id: id,
        platform: _postData.platform,
        dateTime: _postData.dateTime!,
        caption: _postData.caption!.trim(),
        imageUrl: _postData.imageUrl!,
      )
    ]);

    suggestedPostsStore.pop();
    setState(() => _isPostSaving = false);
    _handleBack();
  }

  @override
  void initState() {
    super.initState();
    _loadPostData();
  }

  Widget _buildImage() {
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
          child: SingleChildScrollBare(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: CustomFormTextField(
                    controller: _captionController,
                    previewOnly: true,
                    autocorrect: true,
                    vSize: 7,
                  ),
                ),
              ],
            ),
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
        Positioned(
          top: 5,
          right: 20,
          child: Row(children: [
            Text(
              socialMediaPlatformsOptions[_postData.platform]!,
              style: AppText.bodyBold.merge(AppText.darkText),
            ),
            const Padding(padding: EdgeInsets.only(right: 5)),
            Image.asset(
              socialMediaPlatformsImageUrls[_postData.platform]!,
              width: 14,
              height: 14,
              color: AppColors.dark,
            ),
          ]),
        ),
        if (_isPostSaving)
          Positioned.fill(
            child: Container(
              color: AppColors.light.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutFullPage(
      handleBack: _handleBack,
      paddingOverwrite: pagePaddingNoTop,
      content: Column(
        children: [
          Container(
            width: double.infinity,
            padding: pageHorizontalPadding,
            clipBehavior: Clip.none,
            child: _buildForm(),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: pageHorizontalPadding,
            child: CustomButton(
              disabled: _isPostSaving,
              text: 'Create Scheduled Post',
              handlePressed: _handleCreate,
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

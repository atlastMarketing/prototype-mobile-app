import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:atlast_mobile_app/configs/layout.dart';
import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/constants/social_media_platforms.dart';
import 'package:atlast_mobile_app/models/content_model.dart';
import 'package:atlast_mobile_app/services/generator_service.dart';
import 'package:atlast_mobile_app/shared/animated_loading_dots.dart';
import 'package:atlast_mobile_app/shared/animated_text_blinking.dart';
import 'package:atlast_mobile_app/shared/avatar_image.dart';
import 'package:atlast_mobile_app/shared/form_text_field.dart';
import 'package:atlast_mobile_app/shared/layouts/single_child_scroll_bare.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';

class CalendarEditSinglePost extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;
  final String postId;
  final List<String> initialCaptions;

  const CalendarEditSinglePost({
    Key? key,
    required this.navKey,
    required this.postId,
    this.initialCaptions = const [],
  }) : super(key: key);

  @override
  _CalendarEditSinglePostState createState() => _CalendarEditSinglePostState();
}

class _CalendarEditSinglePostState extends State<CalendarEditSinglePost> {
  final TextEditingController _captionController = TextEditingController();
  bool _isEditingCaption = false;

  bool _isPostLoaded = false;
  late PostContent _postData;

  void _handleBack() {
    widget.navKey.currentState!.pop();
  }

  void _handleSave() {
    widget.navKey.currentState!.pop();
  }

  void _toggleEditState() {
    setState(() => _isEditingCaption = !_isEditingCaption);
  }

  void _loadPostData() async {
    _captionController.text = _postData.caption ?? "";

    setState(() => _isPostLoaded = true);
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
              Image.asset("images/default_placeholder.png"),
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

    DateTime dt = DateTime.fromMillisecondsSinceEpoch(_postData.dateTime!);
    String dtStrMonth = DateFormat.MMM().format(dt).toUpperCase();
    String dtStrDate = DateFormat.d().format(dt);

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                previewOnly: !_isEditingCaption,
                autocorrect: true,
                vSize: 7,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _toggleEditState,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(8),
                      backgroundColor: AppColors.customize,
                      // foregroundColor: AppColors.black,
                    ),
                    child: _isEditingCaption
                        ? const Icon(
                            Icons.save,
                            color: Colors.white,
                            size: 25,
                          )
                        : const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 25,
                          ),
                  ),
                  _isEditingCaption
                      ? const SizedBox.shrink()
                      : ElevatedButton(
                          onPressed: _handleSave,
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(8),
                            backgroundColor: AppColors.confirm,
                            // foregroundColor: AppColors.black,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                ],
              )
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
      content: SingleChildScrollBare(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height - 150,
          padding: pagePadding,
          clipBehavior: Clip.none,
          child: _buildForm(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
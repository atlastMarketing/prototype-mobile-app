import 'package:atlast_mobile_app/configs/layout.dart';
import 'package:atlast_mobile_app/constants/social_media_platforms.dart';
import 'package:atlast_mobile_app/shared/avatar_image.dart';
import 'package:atlast_mobile_app/shared/form_text_field.dart';
import 'package:atlast_mobile_app/shared/layouts/single_child_scroll_bare.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/data/user.dart';
import 'package:atlast_mobile_app/models/content_model.dart';
import 'package:atlast_mobile_app/services/generator_service.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';

class CreatorCampaignSinglePostEdit extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;
  final PostContent postContent;
  final void Function(String a, PostContent b) saveChanges;
  final String prompt;
  final List<String> initialCaptions;

  const CreatorCampaignSinglePostEdit({
    Key? key,
    required this.navKey,
    required this.postContent,
    required this.saveChanges,
    required this.prompt,
    this.initialCaptions = const [],
  }) : super(key: key);

  @override
  _CreatorCampaignSinglePostEditState createState() =>
      _CreatorCampaignSinglePostEditState();
}

class _CreatorCampaignSinglePostEditState
    extends State<CreatorCampaignSinglePostEdit> {
  final TextEditingController _captionController = TextEditingController();
  bool _isEditingCaption = false;
  String _imageUrl = "";

  List<String> _availableCaptions = [];

  int _numGenerations = 0;
  bool _captionsIsLoading = false;

  void _handleBack() {
    widget.navKey.currentState!.pop();
  }

  void _handleSave() {
    widget.saveChanges(
      widget.postContent.id,
      PostContent(
        id: widget.postContent.id,
        platform: widget.postContent.platform,
        dateTime: widget.postContent.dateTime!,
        caption: _captionController.text.trim(),
        imageUrl: _imageUrl,
      ),
    );
    widget.navKey.currentState!.pop();
  }

  void _toggleEditState() {
    setState(() => _isEditingCaption = !_isEditingCaption);
  }

  Future<void> _refreshCaption() async {
    setState(() => _captionsIsLoading = true);

    if (_availableCaptions.isNotEmpty) {
      setState(() {
        _captionController.text = _availableCaptions.removeLast();
        _captionsIsLoading = false;
      });
      return;
    }

    final List<String> response = await GeneratorService.fetchCaptions(
      widget.prompt,
      platform: widget.postContent.platform.toString(),
      userData: Provider.of<UserStore>(context, listen: false).data,
      catalyst: widget.prompt,
      generationNum: _numGenerations + 1,
      numOptions: 3,
    );

    setState(() {
      _numGenerations += 1;
      _captionController.text = response.removeLast();
      _availableCaptions = response;
      _captionsIsLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    // listen for changes to autofill
    _captionController.text = widget.postContent.caption ?? "";
    _imageUrl = widget.postContent.imageUrl ?? "";
    _availableCaptions = widget.initialCaptions;
  }

  Widget _buildImageUploader() {
    return widget.postContent.imageUrl != null
        ? AvatarImage(Uri.encodeFull(_imageUrl))
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
    DateTime dt =
        DateTime.fromMillisecondsSinceEpoch(widget.postContent.dateTime!);
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
                  _isEditingCaption
                      ? const SizedBox.shrink()
                      : ElevatedButton(
                          onPressed:
                              _captionsIsLoading ? null : _refreshCaption,
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(8),
                            backgroundColor: AppColors.error,
                            // foregroundColor: AppColors.black,
                          ),
                          child: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
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
        Positioned(
          top: 5,
          right: 20,
          child: Row(children: [
            Text(
              socialMediaPlatformsOptions[widget.postContent.platform]!,
              style: AppText.bodyBold.merge(AppText.darkText),
            ),
            const Padding(padding: EdgeInsets.only(right: 5)),
            Image.asset(
              socialMediaPlatformsImageUrls[widget.postContent.platform]!,
              width: 14,
              height: 14,
              color: AppColors.dark,
            ),
          ]),
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

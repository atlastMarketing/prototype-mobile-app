import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/models/image_model.dart';
import 'package:atlast_mobile_app/services/image_uploading_service.dart';
import 'package:atlast_mobile_app/shared/app_bar_steps.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/shared/image_uploader.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';

class CreatorSocialMediaPostImage extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;
  final UploadedImage? uploadedImage;
  final void Function(List<UploadedImage>) saveImages;

  const CreatorSocialMediaPostImage({
    Key? key,
    required this.navKey,
    required this.uploadedImage,
    required this.saveImages,
  }) : super(key: key);

  @override
  _CreatorSocialMediaPostImageState createState() =>
      _CreatorSocialMediaPostImageState();
}

class _CreatorSocialMediaPostImageState
    extends State<CreatorSocialMediaPostImage> {
  void _handleBack() {
    widget.navKey.currentState!.pop();
  }

  void _handleContinue() {
    widget.navKey.currentState!.pushNamed("/post-3");
  }

  void _requestImage() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Use camera'),
              onTap: () {
                _getImage(source: ImageSource.camera);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload),
              title: const Text('Upload from gallery'),
              onTap: () {
                _getImage(source: ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _getImage({ImageSource source = ImageSource.camera}) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: source,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    if (pickedFile == null) {
      return;
    }

    File file = File(pickedFile.path);
    String url = await ImageUploadingService.uploadImage(File(pickedFile.path));
    widget.saveImages([UploadedImage(imageUrl: url, image: file)]);
  }

  void _removePicture() {
    widget.saveImages([]);
  }

  Widget _buildImageItem() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Image.file(
            widget.uploadedImage!.image,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            right: 5,
            top: 5,
            child: SizedBox(
              width: 20,
              height: 20,
              child: Material(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: () => _removePicture(),
                  child: const Center(
                    child: Icon(
                      Icons.clear,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImageUploader() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 300,
            child: Text(
              "Upload an image that will be used for your social media post.",
              style: AppText.body,
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 20)),
          ImageUploader(
            handleTap: _requestImage,
            height: 300,
            width: 300,
            iconSize: 50,
            borderColor: AppColors.primary,
            iconColor: AppColors.primary,
          ),
          const Padding(padding: EdgeInsets.only(bottom: 20)),
          SizedBox(
            width: 300,
            child: RichText(
              text: TextSpan(
                style: AppText.body.merge(AppText.blackText),
                children: const <TextSpan>[
                  TextSpan(
                    text: 'Feel free take a couple seconds to take ',
                    style: AppText.body,
                  ),
                  TextSpan(
                    text: 'real pictures ',
                    style: AppText.bodyBold,
                  ),
                  TextSpan(
                    text: 'from around your shop.',
                    style: AppText.body,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutFullPage(
      handleBack: _handleBack,
      appBarContent: const AppBarSteps(totalSteps: 4, currStep: 2),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeroHeading(text: "Upload your media"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              child: widget.uploadedImage != null
                  ? _buildImageItem()
                  : _buildImageUploader(),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              handlePressed: _handleContinue,
              fillColor: AppColors.primary,
              text: widget.uploadedImage != null ? 'Continue' : 'Skip',
            ),
          ),
        ],
      ),
    );
  }
}

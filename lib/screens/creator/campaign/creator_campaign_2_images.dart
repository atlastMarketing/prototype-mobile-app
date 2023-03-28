import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/models/image_model.dart';
import 'package:atlast_mobile_app/shared/app_bar_steps.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/help_popup.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/shared/image_uploader.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';
import 'package:atlast_mobile_app/services/image_uploading_service.dart';

class CreatorCampaignImages extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;
  final List<UploadedImage> images;
  final void Function(List<UploadedImage>) saveImages;

  const CreatorCampaignImages({
    Key? key,
    required this.navKey,
    required this.images,
    required this.saveImages,
  }) : super(key: key);

  @override
  _CreatorCampaignImagesState createState() => _CreatorCampaignImagesState();
}

class _CreatorCampaignImagesState extends State<CreatorCampaignImages> {
  void _handleBack() {
    widget.navKey.currentState!.pop();
  }

  void _handleContinue() {
    widget.navKey.currentState!.pushNamed("/campaign-3");
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
    widget.saveImages([
      ...widget.images,
      UploadedImage(
        image: file,
        imageUrl: url,
      )
    ]);
  }

  void _removePicture(int idx) {
    List<UploadedImage> removed = widget.images;
    removed.removeAt(idx);
    widget.saveImages(removed);
  }

  Widget _buildImageItem(int idx, File imageFile) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Image.file(imageFile, width: double.infinity, fit: BoxFit.cover),
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
                  onTap: () => _removePicture(idx),
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

  @override
  Widget build(BuildContext context) {
    return LayoutFullPage(
      handleBack: _handleBack,
      appBarContent: const AppBarSteps(totalSteps: 3, currStep: 2),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeroHeading(text: "Upload your media"),
          Expanded(
            child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: List.generate(
                  9,
                  (idx) => idx < widget.images.length
                      ? _buildImageItem(idx, widget.images[idx].image)
                      : idx == 8
                          ? HelpPopup(
                              title: "Marketer's tip",
                              content:
                                  "Take a couple seconds to take real pictures around your shop – this makes a huge difference.\n\n- Your AI Marketing Assistant",
                              highlight: false,
                              child: ImageUploader(
                                handleTap: _requestImage,
                                iconSize: MediaQuery.of(context).size.width / 6,
                              ),
                            )
                          : ImageUploader(
                              handleTap: _requestImage,
                              iconSize: MediaQuery.of(context).size.width / 6,
                            ),
                )),
          ),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              handlePressed: _handleContinue,
              fillColor: AppColors.primary,
              text: 'Generate',
            ),
          ),
        ],
      ),
    );
  }
}

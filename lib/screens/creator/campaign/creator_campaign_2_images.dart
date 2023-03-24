import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/shared/app_bar_steps.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';
import 'package:atlast_mobile_app/services/image_uploading_service.dart';

class CreatorCampaignImages extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;
  final List<String> images;
  final void Function(List<String>) saveImages;

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
  List<File> imageFiles = [];

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
      print("did not upload image!");
      return;
    }

    String url = await ImageUploadingService.uploadImage(File(pickedFile.path));
    setState(() => imageFiles.add(File(pickedFile.path)));
    widget.saveImages([...widget.images, url]);
  }

  void _removePicture(int idx) {
    setState(() => imageFiles.removeAt(idx));
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
            child: Container(
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

  Widget _buildUploaderItem() {
    return Material(
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: _requestImage,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.dark.withOpacity(0.3),
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.add,
            color: AppColors.dark.withOpacity(0.5),
            size: MediaQuery.of(context).size.width / 6,
          ),
        ),
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
                  (idx) => idx < imageFiles.length
                      ? _buildImageItem(idx, imageFiles[idx])
                      : _buildUploaderItem(),
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

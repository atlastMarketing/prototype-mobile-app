import 'dart:io';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/services/image_uploading_service.dart';
import 'package:flutter/material.dart';
import 'package:info_popup/info_popup.dart';

import 'package:image_picker/image_picker.dart';

class CreatorSocialMediaPostImage extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;
  final Function(String) saveImageUrl;

  const CreatorSocialMediaPostImage({
    Key? key,
    required this.navKey,
    required this.saveImageUrl,
  }) : super(key: key);

  @override
  _CreatorSocialMediaPostImageState createState() =>
      _CreatorSocialMediaPostImageState();
}

class _CreatorSocialMediaPostImageState
    extends State<CreatorSocialMediaPostImage> {
  File? imageFile;
  bool infoPopupDismissed = false;

  void _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    String url =
        await ImageUploadingService.uploadImage(File(pickedFile!.path));
    widget.saveImageUrl(url);
    setState(() {
      imageFile = File(pickedFile!.path);
    });
    // Navigator.pop(context);
    widget.navKey.currentState!.pushNamed("/post-results");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          imageFile != null
              ? Image.file(imageFile!)
              : Icon(
                  Icons.camera_enhance_rounded,
                  color: AppColors.secondary,
                  size: MediaQuery.of(context).size.width * .6,
                ),
          Padding(
              padding: const EdgeInsets.all(30.0),
              child: ElevatedButton(
                  onPressed: () {
                    _getFromCamera();
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.primary),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(20)),
                      textStyle:
                          MaterialStateProperty.all(AppText.buttonLargeText)),
                  child: infoPopupDismissed == false
                      ? InfoPopupWidget(
                          onControllerCreated:
                              (InfoPopupController controller) {
                            controller.show();
                          },
                          infoPopupDismissed: () {
                            setState(() => infoPopupDismissed = true);
                          },
                          contentTitle:
                              "1. Use good lighting: Ensure the product is well-lit and avoid harsh shadows or glares.\n2. Focus on the product: Keep the focus on the product and avoid cluttered backgrounds or distracting elements.\n3. Use a visually appealing composition: Experiment with different angles and compositions to find the most attractive way to showcase the product.\n4. Showcase product benefits: Highlight the product's unique features and benefits in the caption or description.\n5. Keep it consistent: Maintain a consistent visual style across all your social media posts to create a cohesive brand image.\n\n- Your AI Marketing Advisor",
                          enableHighlight: true,
                          child: const Text('Take a Picture for your Post'))
                      : const Text('Take a Picture for your Post')))
        ],
      ),
    );
  }
}

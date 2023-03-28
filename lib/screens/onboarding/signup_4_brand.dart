import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/data/user.dart';
import 'package:atlast_mobile_app/models/image_model.dart';
import 'package:atlast_mobile_app/services/image_uploading_service.dart';
import 'package:atlast_mobile_app/shared/app_bar_steps.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/form_text_field.dart';
import 'package:atlast_mobile_app/shared/help_popup.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/shared/image_uploader.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';
import 'package:atlast_mobile_app/shared/layouts/single_child_scroll_bare.dart';

class OnboardingBranding extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;

  const OnboardingBranding({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  @override
  _OnboardingBrandingState createState() => _OnboardingBrandingState();
}

class _OnboardingBrandingState extends State<OnboardingBranding> {
  // form variables
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _businessVoiceController =
      TextEditingController();

  String _imageUrl = "";
  UploadedImage? _uploadedImage;

  void _handleBack() {
    widget.navKey.currentState!.pop();
  }

  void _handleContinue() {
    Provider.of<UserStore>(context, listen: false).update(
      businessVoice: _businessVoiceController.text,
      avatarImageUrl: _uploadedImage?.imageUrl ?? _imageUrl,
    );
    widget.navKey.currentState!.pushNamed("/onboarding-5");
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
    setState(() => _uploadedImage = UploadedImage(
          image: file,
          imageUrl: url,
        ));
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

  Widget _buildImageItem() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          _uploadedImage != null
              ? Image.file(
                  _uploadedImage!.image,
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  Uri.encodeFull(_imageUrl),
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (_, obj, stack) => Image.asset(
                    "assets/images/default_placeholder.png",
                    fit: BoxFit.cover,
                  ),
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
                  onTap: () => setState(() {
                    _uploadedImage = null;
                  }),
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
  void initState() {
    super.initState();
    _businessVoiceController.text =
        Provider.of<UserStore>(context, listen: false).data.businessVoice ?? "";

    _imageUrl =
        Provider.of<UserStore>(context, listen: false).data.avatarImageUrl ??
            "";
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollBare(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Upload your logo",
              style: AppText.bodyBold,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: Center(
                child: _imageUrl != "" && _uploadedImage != null
                    ? _buildImageItem()
                    : ImageUploader(
                        handleTap: _requestImage,
                        iconSize: MediaQuery.of(context).size.width / 6,
                        height: 120,
                        width: 120,
                      ),
              ),
            ),
            const Text(
              "What adjectives best describe your business?",
              style: AppText.bodyBold,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: HelpPopup(
                title: "Terminology",
                content:
                    "A brand identity is the visual representation of your brand.",
                child: CustomFormTextField(
                  controller: _businessVoiceController,
                  placeholderText:
                      "Ex. Fun, Colourful, Casual, Family-oriented",
                  autocorrect: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutFullPage(
      handleBack: _handleBack,
      appBarContent: const AppBarSteps(totalSteps: 5, currStep: 4),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeroHeading(text: "Your Business"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildForm(),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              handlePressed: () {
                _formKey.currentState!.save();
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  _handleContinue();
                }
              },
              fillColor: AppColors.primary,
              text: 'Continue',
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _businessVoiceController.dispose();
    super.dispose();
  }
}

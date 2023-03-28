import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:atlast_mobile_app/configs/layout.dart';
import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/constants/business_info.dart';
import 'package:atlast_mobile_app/data/user.dart';
import 'package:atlast_mobile_app/models/image_model.dart';
import 'package:atlast_mobile_app/models/user_model.dart';
import 'package:atlast_mobile_app/services/image_uploading_service.dart';
import 'package:atlast_mobile_app/services/user_service.dart';
import 'package:atlast_mobile_app/shared/form_text_dropdown.dart';
import 'package:atlast_mobile_app/shared/form_text_field.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/shared/image_uploader.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';
import 'package:atlast_mobile_app/shared/layouts/single_child_scroll_bare.dart';

class UserProfileEdit extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;

  const UserProfileEdit({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  @override
  _UserProfileEditState createState() => _UserProfileEditState();
}

class _UserProfileEditState extends State<UserProfileEdit> {
  bool _isSaving = false;
  UploadedImage? _uploadedImage;

  // form variables
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bNameController = TextEditingController();
  String _bTypeInput = businessTypes[0];
  String _bIndustryInput = businessIndustries[0];
  final TextEditingController _bDescriptionController = TextEditingController();
  final TextEditingController _bVoiceController = TextEditingController();
  final TextEditingController _bUrlController = TextEditingController();
  final TextEditingController _avatarImageUrlController =
      TextEditingController();

  void _setBTypeInput(dynamic val) => setState(() => _bTypeInput = val);
  void _setBIndustryInput(dynamic val) => setState(() => _bIndustryInput = val);

  void _handleBack() {
    widget.navKey.currentState!.pop();
  }

  void _handleSave() async {
    try {
      setState(() => _isSaving = true);
      UserStore userStoreProvider =
          Provider.of<UserStore>(context, listen: false);

      userStoreProvider.update(
        businessName: _bNameController.text,
        businessType: _bTypeInput,
        businessIndustry: _bIndustryInput,
        businessDescription: _bDescriptionController.text,
        businessVoice: _bVoiceController.text,
        businessUrl: _bUrlController.text,
        avatarImageUrl: _avatarImageUrlController.text,
      );
      await UserService.updateAccount(userStoreProvider.data);
    } catch (err) {
      print(err);
    } finally {
      setState(() => _isSaving = false);
      widget.navKey.currentState!.pop();
    }
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

  @override
  void initState() {
    super.initState();

    UserModel userData = Provider.of<UserStore>(context, listen: false).data;

    _bNameController.text = userData.businessName ?? "";
    String? initialBType = userData.businessType;
    if (initialBType != null && initialBType != "") _bTypeInput = initialBType;
    String? initialBIndustry = userData.businessIndustry;
    if (initialBIndustry != null && initialBIndustry != "") {
      _bIndustryInput = initialBIndustry;
    }
    _bNameController.text = userData.businessName ?? "";
    _bDescriptionController.text = userData.businessDescription ?? "";
    _bVoiceController.text = userData.businessVoice ?? "";
    _bUrlController.text = userData.businessUrl ?? "";
    _avatarImageUrlController.text = userData.avatarImageUrl ?? "";
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
                  Uri.encodeFull(_avatarImageUrlController.text),
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

  Widget _buildForm() {
    UserModel userData = Provider.of<UserStore>(context, listen: false).data;

    return Form(
      key: _formKey,
      child: SingleChildScrollBare(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: userData.avatarImageUrl != "" && _uploadedImage != null
                  ? _buildImageItem()
                  : ImageUploader(
                      handleTap: _requestImage,
                      iconSize: MediaQuery.of(context).size.width / 6,
                      height: 120,
                      width: 120,
                    ),
            ),
            const Text(
              "Name of Business",
              style: AppText.bodyBold,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: CustomFormTextField(
                controller: _bNameController,
                placeholderText: "Ex. Picard's Flower Shop",
                validator: (String? val) {
                  if (val == null || val == "") {
                    return 'Business name cannot be empty!';
                  }
                },
              ),
            ),
            const Text(
              "Types of products or services your business sells/offers",
              style: AppText.bodyBold,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: CustomFormTextDropdown(
                value: _bTypeInput,
                handleChanged: _setBTypeInput,
                items: businessTypes,
              ),
            ),
            const Text(
              "Industry",
              style: AppText.bodyBold,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: CustomFormTextDropdown(
                value: _bIndustryInput,
                handleChanged: _setBIndustryInput,
                items: businessIndustries,
              ),
            ),
            const Text(
              "Bsuiness Description",
              style: AppText.bodyBold,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: CustomFormTextField(
                controller: _bDescriptionController,
                placeholderText:
                    "Ex. My flower shop is a family owned business offering a wide variety of plants, florals, and bouquets.",
                vSize: 10,
                validator: (String? val) {
                  if (val == null || val == "") {
                    return 'Business description cannot be empty!';
                  }
                },
                autocorrect: true,
              ),
            ),
            const Text(
              "Business Adjectives/Voice",
              style: AppText.bodyBold,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: CustomFormTextField(
                controller: _bVoiceController,
                placeholderText: "Ex. Fun, Colourful, Casual, Family-oriented",
                autocorrect: true,
              ),
            ),
            const Text(
              "Business Website",
              style: AppText.bodyBold,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: CustomFormTextField(
                controller: _bUrlController,
                placeholderText: "https://",
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
      paddingOverwrite: pagePaddingNoBottom,
      actionWidgets: [
        IconButton(
          icon: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: AppColors.black),
                )
              : const Icon(Icons.check, color: Colors.grey, size: 30),
          onPressed: _handleSave,
        ),
      ],
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeroHeading(text: "Edit Your Profile"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildForm(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bNameController.dispose();
    super.dispose();
  }
}

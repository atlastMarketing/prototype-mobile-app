import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/app_bar_steps.dart';
import 'package:atlast_mobile_app/shared/form_text_field.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';

class CreateCampaignMedia extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;

  const CreateCampaignMedia({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  @override
  _CreateCampaignMediaState createState() => _CreateCampaignMediaState();
}

class _CreateCampaignMediaState extends State<CreateCampaignMedia> {
  // form variables
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  List<String> _listOfSelectedPlatforms = [];

  void _setListOfSelectedPlatforms(List<String> newList) {
    setState(() => _listOfSelectedPlatforms = newList);
  }

  void _handleBack() {
    widget.navKey.currentState!.pop();
  }

  void _handleContinue() {
    print("campaign description: ${_descriptionController.text}");
    widget.navKey.currentState!.pushNamed("/campaign-2");
  }

  @override
  Widget build(BuildContext context) {
    return LayoutFullPage(
      handleBack: _handleBack,
      appBarContent: const AppBarSteps(totalSteps: 4, currStep: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeroHeading(text: "Upload your Media"),
          const Padding(padding: EdgeInsets.only(bottom: 5)),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "TODO: Media Upload",
                  style: AppText.bodyBold,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: CustomFormTextField(
                    controller: _descriptionController,
                    placeholderText:
                        "Ex. Valentines days promotion for \$20 for a dozen roses and free delivery",
                    vSize: 6,
                    // TODO: add auto analysis of description to pre-fill other fields
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
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
}

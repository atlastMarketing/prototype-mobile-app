import 'package:atlast_mobile_app/shared/layouts/single_child_scroll_bare.dart';
import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/constants/social_media_platforms.dart';

import 'package:atlast_mobile_app/shared/app_bar_steps.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/form_date_picker.dart';
import 'package:atlast_mobile_app/shared/form_multiselect_dropdown.dart';
import 'package:atlast_mobile_app/shared/form_text_field.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';

class CreatorCampaignDescription extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;

  const CreatorCampaignDescription({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  @override
  _CreatorCampaignDescriptionState createState() =>
      _CreatorCampaignDescriptionState();
}

class _CreatorCampaignDescriptionState
    extends State<CreatorCampaignDescription> {
  // form variables
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  List<String> _listOfSelectedPlatforms = [];
  bool _listOfSelectedPlatformsHasError = false;
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  bool _dateControllersHasError = false;

  void _setListOfSelectedPlatforms(List<String> newList) {
    setState(() => _listOfSelectedPlatforms = newList);
  }

  void _handleBack() {
    widget.navKey.currentState!.pop();
  }

  void _handleContinue() {
    widget.navKey.currentState!.pushNamed("/campaign-2");
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "What is your campaign about?",
            style: AppText.bodyBold,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            child: CustomFormTextField(
              controller: _descriptionController,
              placeholderText:
                  "Ex. Valentines days promotion for \$20 for a dozen roses and free delivery",
              vSize: 6,
              // TODO: add auto analysis of description to pre-fill other fields
            ),
          ),
          const Text(
            "What account(s) do you want to post on?",
            style: AppText.bodyBold,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            child: Column(
              children: [
                CustomFormMultiselectDropdown(
                  listOfOptions: socialMediaPlatforms,
                  listOfSelectedOptions: _listOfSelectedPlatforms,
                  setListOfSelectedOptions: _setListOfSelectedPlatforms,
                  placeholder: "Select platform(s)",
                  hasError: _listOfSelectedPlatformsHasError,
                  validationMsg: "Must select at least one platform",
                ),
                Row(
                  children: [
                    const Icon(Icons.auto_awesome,
                        size: 10, color: AppColors.primary),
                    const Padding(padding: EdgeInsets.only(right: 5)),
                    Text(
                      "Auto-filled using Atlast smart suggestions",
                      style: AppText.bodySemiBold
                          .merge(AppText.primaryText)
                          .merge(AppText.bodySmall),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Text(
            "What is the duration of your campaign?",
            style: AppText.bodyBold,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: CustomFormDatePicker(
                        controller: _startDateController,
                        setDate: (String date) =>
                            setState(() => _startDateController.text = date),
                        placeholderText: "Start date",
                        startDate: DateTime.now(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                          height: 1, width: 15, color: AppColors.black),
                    ),
                    Flexible(
                      child: CustomFormDatePicker(
                        controller: _endDateController,
                        setDate: (String date) =>
                            setState(() => _endDateController.text = date),
                        placeholderText: "End date",
                        startDate: _startDateController.text != ""
                            ? DateTime.tryParse(_startDateController.text)
                            : DateTime.now(),
                      ),
                    ),
                  ],
                ),
                _dateControllersHasError
                    ? const Text(
                        "Start and end date cannot be empty!",
                        style: TextStyle(color: AppColors.error),
                      )
                    : const SizedBox(height: 0),
                Row(
                  children: [
                    const Icon(Icons.auto_awesome,
                        size: 10, color: AppColors.primary),
                    const Padding(padding: EdgeInsets.only(right: 5)),
                    Text(
                      "Auto-filled using Atlast smart suggestions",
                      style: AppText.bodySemiBold
                          .merge(AppText.primaryText)
                          .merge(AppText.bodySmall),
                    ),
                  ],
                ),
              ],
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
      appBarContent: const AppBarSteps(totalSteps: 4, currStep: 1),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeroHeading(text: "Make a Campaign"),
          Expanded(
            child: SingleChildScrollBare(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildForm(),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              handlePressed: () {
                _formKey.currentState!.save();
                // Validate returns true if the form is valid, or false otherwise.
                bool platformsErrorCheck = _listOfSelectedPlatforms.length < 1;
                bool datesErrorCheck = _startDateController.text == "" ||
                    _endDateController.text == "";
                if (platformsErrorCheck != _listOfSelectedPlatformsHasError ||
                    datesErrorCheck != _dateControllersHasError) {
                  setState(() {
                    _listOfSelectedPlatformsHasError = platformsErrorCheck;
                    _dateControllersHasError = datesErrorCheck;
                  });
                }

                if (_formKey.currentState!.validate() &&
                    !platformsErrorCheck &&
                    !datesErrorCheck) {
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

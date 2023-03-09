import 'package:atlast_mobile_app/shared/layouts/single_child_scroll_bare.dart';
import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/constants/business_info.dart';
import 'package:atlast_mobile_app/utils/form_validations.dart';

import 'package:atlast_mobile_app/shared/app_bar_steps.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/form_text_dropdown.dart';
import 'package:atlast_mobile_app/shared/form_text_field.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';

class OnboardingBusiness extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;

  const OnboardingBusiness({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  @override
  _OnboardingBusinessState createState() => _OnboardingBusinessState();
}

class _OnboardingBusinessState extends State<OnboardingBusiness> {
  // form variables
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bNameController = TextEditingController();
  String _bTypeInput = businessTypes[0];
  String _bIndustryInput = businessIndustries[0];

  void _setBTypeInput(dynamic val) => setState(() => _bTypeInput = val);

  void _setBIndustryInput(dynamic val) => setState(() => _bIndustryInput = val);

  void _handleBack() {
    widget.navKey.currentState!.pop();
  }

  void _handleContinue() {
    print("Business Name: ${_bNameController.text}");
    print("Business Type: ${_bTypeInput}");
    print("Business Industry: ${_bIndustryInput}");
    widget.navKey.currentState!.pushNamed("/create-3");
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollBare(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "What is the name of your business?",
              style: AppText.bodyBold,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: CustomFormTextField(
                controller: _bNameController,
                placeholderText: "Ex. Starbucks",
                validator: (String? val) {
                  if (!isValidName(val)) {
                    return 'Business name cannot be empty or contain special characters!';
                  }
                },
              ),
            ),
            const Text(
              "What types of products or services does your business sell/offer?",
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
              "What industry reflects your business?",
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutFullPage(
      handleBack: _handleBack,
      appBarContent: const AppBarSteps(totalSteps: 2, currStep: 2),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeroHeading(text: "Tell us about you"),
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
}

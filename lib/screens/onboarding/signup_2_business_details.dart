import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/constants/business_info.dart';
import 'package:atlast_mobile_app/data/user.dart';
import 'package:atlast_mobile_app/shared/app_bar_steps.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/form_text_dropdown.dart';
import 'package:atlast_mobile_app/shared/form_text_field.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';
import 'package:atlast_mobile_app/shared/layouts/single_child_scroll_bare.dart';

class OnboardingBusinessDetails extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;

  const OnboardingBusinessDetails({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  @override
  _OnboardingBusinessDetailsState createState() =>
      _OnboardingBusinessDetailsState();
}

class _OnboardingBusinessDetailsState extends State<OnboardingBusinessDetails> {
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
    Provider.of<UserStore>(context, listen: false).update(
      businessName: _bNameController.text,
      businessType: _bTypeInput,
      businessIndustry: _bIndustryInput,
    );
    widget.navKey.currentState!.pushNamed("/onboarding-3");
  }

  @override
  void initState() {
    super.initState();
    String? initialBType =
        Provider.of<UserStore>(context, listen: false).data.businessType;
    if (initialBType != null && initialBType != "") _bTypeInput = initialBType;

    String? initialBIndustry =
        Provider.of<UserStore>(context, listen: false).data.businessIndustry;
    if (initialBIndustry != null && initialBIndustry != "") {
      _bIndustryInput = initialBIndustry;
    }
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
                placeholderText: "Ex. Picard's Flower Shop",
                validator: (String? val) {
                  if (val == null || val == "") {
                    return 'Business name cannot be empty!';
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
      appBarContent: const AppBarSteps(totalSteps: 5, currStep: 2),
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

  @override
  void dispose() {
    _bNameController.dispose();
    super.dispose();
  }
}

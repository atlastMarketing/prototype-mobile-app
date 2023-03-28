import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/data/user.dart';
import 'package:atlast_mobile_app/shared/app_bar_steps.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/form_text_field.dart';
import 'package:atlast_mobile_app/shared/help_popup.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';
import 'package:atlast_mobile_app/shared/layouts/single_child_scroll_bare.dart';

class OnboardingBusinessDescription extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;

  const OnboardingBusinessDescription({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  @override
  _OnboardingBusinessDescriptionState createState() =>
      _OnboardingBusinessDescriptionState();
}

class _OnboardingBusinessDescriptionState
    extends State<OnboardingBusinessDescription> {
  // form variables
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _businessDescriptionController =
      TextEditingController();

  void _handleBack() {
    widget.navKey.currentState!.pop();
  }

  void _handleContinue() {
    Provider.of<UserStore>(context, listen: false).update(
      businessDescription: _businessDescriptionController.text,
    );
    FocusManager.instance.primaryFocus?.unfocus();
    widget.navKey.currentState!.pushNamed("/onboarding-4");
  }

  @override
  void initState() {
    super.initState();
    _businessDescriptionController.text =
        Provider.of<UserStore>(context, listen: false)
                .data
                .businessDescription ??
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
              "How would you describe your business?",
              style: AppText.bodyBold,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: HelpPopup(
                disabled: _businessDescriptionController.text.isNotEmpty,
                // delayMilliseconds: 5000,
                title: "Stuck? fret not!",
                content:
                    "Feel free to describe your business in any way - the more detailed the better! But don't worry too much - our system will learn more about your business over time.",
                child: CustomFormTextField(
                  controller: _businessDescriptionController,
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
      appBarContent: const AppBarSteps(totalSteps: 5, currStep: 3),
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
    _businessDescriptionController.dispose();
    super.dispose();
  }
}

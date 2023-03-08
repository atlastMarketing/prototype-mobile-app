import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/form_text_field.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';
import 'package:atlast_mobile_app/utils/form_validations.dart';

import './widgets/app_bar_steps.dart';

class OnboardingEmail extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;

  OnboardingEmail({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  // form variables
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  void _handleBack() {
    navKey.currentState!.pop();
  }

  void _handleContinue() {
    print("email: ${_emailController.text}");
    navKey.currentState!.pushNamed("/create-2");
  }

  @override
  Widget build(BuildContext context) {
    return LayoutFullPage(
      handleBack: _handleBack,
      appBarContent: const AppBarSteps(totalSteps: 2, currStep: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeroHeading(text: "Let's get started!"),
          const Padding(padding: EdgeInsets.only(bottom: 5)),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "What's your email address?",
                  style: AppText.bodyBold,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: CustomFormTextField(
                    controller: _emailController,
                    placeholderText: "name@example.com",
                    validator: (String? val) {
                      if (!isValidEmail(val)) {
                        return 'Enter a valid email!';
                      }
                    },
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

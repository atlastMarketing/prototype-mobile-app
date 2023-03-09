import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/data/user.dart';
import 'package:atlast_mobile_app/utils/form_validations.dart';

import 'package:atlast_mobile_app/shared/app_bar_steps.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/form_text_field.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';

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

  void _handleContinue(BuildContext ctx) {
    print("email: ${_emailController.text}");
    Provider.of<UserModel>(ctx, listen: false)
        .updateUser(email: _emailController.text);
    navKey.currentState!.pushNamed("/creator-2");
  }

  Widget _buildForm(BuildContext ctx) {
    _emailController.text =
        Provider.of<UserModel>(ctx, listen: false).data.email ?? "";
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "What's your email address?",
            style: AppText.bodyBold,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 30),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutFullPage(
      handleBack: _handleBack,
      appBarContent: const AppBarSteps(totalSteps: 2, currStep: 1),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeroHeading(text: "Let's get started!"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildForm(context),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              handlePressed: () {
                _formKey.currentState!.save();
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  _handleContinue(context);
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

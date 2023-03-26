import 'package:atlast_mobile_app/shared/help_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/data/user.dart';
import 'package:atlast_mobile_app/shared/app_bar_steps.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/form_text_field.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';
import 'package:atlast_mobile_app/shared/layouts/single_child_scroll_bare.dart';

class OnboardingConnect extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;

  const OnboardingConnect({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  @override
  _OnboardingConnectState createState() => _OnboardingConnectState();
}

class _OnboardingConnectState extends State<OnboardingConnect> {
  // form variables
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _businessUrlController = TextEditingController();

  bool _instagramActive = false;
  bool _facebookActive = false;
  bool _twitterActive = false;
  bool _linkedinActive = false;

  void _handleBack() {
    widget.navKey.currentState!.pop();
  }

  void _handleContinue() {
    Provider.of<UserStore>(context, listen: false).update(
      businessUrl: _businessUrlController.text,
    );
    widget.navKey.currentState!.pushNamed("/onboarding-confirm");
  }

  @override
  void initState() {
    super.initState();
    _businessUrlController.text =
        Provider.of<UserStore>(context, listen: false).data.businessUrl ?? "";
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollBare(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Do you have a website?",
              style: AppText.bodyBold,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: CustomFormTextField(
                controller: _businessUrlController,
                placeholderText: "https://",
              ),
            ),
            const Text(
              "Connect your social media accounts",
              style: AppText.bodyBold,
            ),
            HelpPopup(
              title: "Why?",
              content:
                  "By allowing us to view your current accounts, we can better understand your visual identity",
              child: _buildSocialMediaConnections(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaConnections() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () => setState(() => _instagramActive = !_instagramActive),
            child: Image.asset(
              "images/instagram.png",
              color: _instagramActive ? AppColors.primary : null,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () => setState(() => _facebookActive = !_facebookActive),
            child: Image.asset(
              "images/facebook.png",
              color: _facebookActive ? AppColors.primary : null,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () => setState(() => _linkedinActive = !_linkedinActive),
            child: Image.asset(
              "images/linkedin.png",
              color: _linkedinActive ? AppColors.primary : null,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () => setState(() => _twitterActive = !_twitterActive),
            child: Image.asset(
              "images/twitter.png",
              color: _twitterActive ? AppColors.primary : null,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutFullPage(
      handleBack: _handleBack,
      appBarContent: const AppBarSteps(totalSteps: 5, currStep: 5),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeroHeading(text: "Let's Connect"),
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
    _businessUrlController.dispose();
    super.dispose();
  }
}

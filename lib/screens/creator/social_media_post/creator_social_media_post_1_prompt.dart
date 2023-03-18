import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/constants/catalyst_output_types.dart';
import 'package:atlast_mobile_app/models/catalyst_model.dart';
import 'package:atlast_mobile_app/shared/app_bar_steps.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/form_text_field.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';
import 'package:atlast_mobile_app/shared/layouts/single_child_scroll_bare.dart';

class CreatorSocialMediaPostPrompt extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;
  final Future<void> Function(
    String catalyst, {
    CatalystOutputTypes type,
  }) analyzeCatalyst;
  final CatalystBreakdown? catalyst;

  const CreatorSocialMediaPostPrompt({
    Key? key,
    required this.navKey,
    required this.analyzeCatalyst,
    required this.catalyst,
  }) : super(key: key);

  @override
  _CreatorSocialMediaPostPromptState createState() =>
      _CreatorSocialMediaPostPromptState();
}

class _CreatorSocialMediaPostPromptState
    extends State<CreatorSocialMediaPostPrompt> {
  // form variables
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _catalystInputController =
      TextEditingController();

  void _handleBack() {
    widget.navKey.currentState!.pop();
  }

  void _handleContinue() {
    widget.navKey.currentState!.pushNamed("/post-results");
  }

  void _handleChange() {
    widget.analyzeCatalyst(
      _catalystInputController.text,
      type: CatalystOutputTypes.singlePost,
    );
  }

  Widget _buildDate() {
    if (widget.catalyst == null ||
        widget.catalyst!.derivedPostTimestamp == null) {
      return const SizedBox(height: 0, width: 0);
    }

    String date = DateTime.fromMillisecondsSinceEpoch(
            widget.catalyst!.derivedPostTimestamp!)
        .toIso8601String();
    return Row(
      children: [
        const Text("Date: "),
        Text(widget.catalyst!.derivedPostTimestamp.toString()),
        const Text(" ---- "),
        Text(date),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    // listen for changes to autofill
    _catalystInputController.addListener(_handleChange);
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Describe what your post is about!",
            style: AppText.bodyBold,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            child: CustomFormTextField(
              controller: _catalystInputController,
              placeholderText:
                  // "Ex. Instagram post on Valentines day about promoting a discount of \$20 for a dozen roses and free delivery",
                  "Ex. Post on February 13 at 9pm about a Valentine's day promotion of \$20 for a dozen roses and free delivery",
              vSize: 6,
              // TODO: add auto analysis of description to pre-fill other fields
              validator: (String? val) {
                // TODO: remove validator
                if (val == null || val == "") {
                  return 'Enter a valid description!';
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            child: Column(children: [
              _buildDate(),
            ]),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutFullPage(
      handleBack: _handleBack,
      appBarContent: const AppBarSteps(totalSteps: 3, currStep: 1),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeroHeading(text: "Make a Post"),
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
    _catalystInputController.removeListener(_handleChange);
    _catalystInputController.dispose();
    super.dispose();
  }
}

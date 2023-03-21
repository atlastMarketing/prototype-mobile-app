import 'package:atlast_mobile_app/constants/social_media_platforms.dart';
import 'package:atlast_mobile_app/shared/annotated_text_field.dart';
import 'package:atlast_mobile_app/shared/form_text_field.dart';
import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/constants/catalyst_output_types.dart';
import 'package:atlast_mobile_app/models/catalyst_model.dart';
import 'package:atlast_mobile_app/shared/app_bar_steps.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';
import 'package:atlast_mobile_app/shared/layouts/single_child_scroll_bare.dart';
import 'package:intl/intl.dart';

class CreatorSocialMediaPostPrompt extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;
  final Future<void> Function(
    String catalyst, {
    CatalystOutputTypes type,
  }) analyzeCatalyst;
  final CatalystBreakdown? catalyst;
  final List<DateAnnotation> dateAnnotations;
  final List<SocialMediaPlatformAnnotation> socialMediaPlatformAnnotations;

  const CreatorSocialMediaPostPrompt({
    Key? key,
    required this.navKey,
    required this.analyzeCatalyst,
    required this.catalyst,
    required this.dateAnnotations,
    required this.socialMediaPlatformAnnotations,
  }) : super(key: key);

  @override
  _CreatorSocialMediaPostPromptState createState() =>
      _CreatorSocialMediaPostPromptState();
}

class _CreatorSocialMediaPostPromptState
    extends State<CreatorSocialMediaPostPrompt> {
  // form variables
  final _formKey = GlobalKey<FormState>();
  // final TextEditingController _catalystInputController =
  //     TextEditingController();
  final AnnotatedTextController _catalystInputController =
      AnnotatedTextController();

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
        widget.catalyst!.derivedPostTimestamps.isEmpty) {
      return const SizedBox(height: 0, width: 0);
    }

    return Row(
      children: [
        const Text("Dates: ", style: AppText.bodyBold),
        Column(
            children: widget.catalyst!.derivedPostTimestamps.map((timestamp) {
          DateTime date =
              DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
          return Text(
              "${DateFormat.yMMMMd().format(date)} ${DateFormat.jms().format(date)}");
        }).toList()),
      ],
    );
  }

  Widget _buildPlatforms() {
    if (widget.socialMediaPlatformAnnotations.isEmpty) {
      return const SizedBox(height: 0, width: 0);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Platforms: ", style: AppText.bodyBold),
        Column(
          children: widget.socialMediaPlatformAnnotations
              .map(
                  (annot) => Text(socialMediaPlatformsOptions[annot.platform]!))
              .toList(),
        ),
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
    List<Annotation> textAnnotations = [];
    textAnnotations.addAll(widget.dateAnnotations.map(
      (annot) => Annotation(
        range: annot.range,
        style: annot.style,
      ),
    ));
    textAnnotations.addAll(widget.socialMediaPlatformAnnotations.map(
      (annot) => Annotation(
        range: annot.range,
        style: annot.style,
      ),
    ));
    _catalystInputController.annotations = textAnnotations;

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
          // Padding(
          //   padding: const EdgeInsets.only(top: 10, bottom: 30),
          //   child: Container(
          //     width: double.infinity,
          //     height: 200,
          //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          //     decoration: BoxDecoration(
          //       border: Border.all(color: AppColors.black),
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //     child: AnnotatedEditableText(
          //       controller: _catalystInputController,
          //       // placeholderText:
          //       //     // "Ex. Instagram post on Valentines day about promoting a discount of \$20 for a dozen roses and free delivery",
          //       //     "Ex. Post on February 13 at 9pm about a Valentine's day promotion of \$20 for a dozen roses and free delivery",
          //       vSize: 6,
          //       focusNode: FocusNode(onKeyEvent: (FocusNode node, KeyEvent e) {
          //         print("hasFocus: ${node.hasFocus}");
          //         print("hasPrimaryFocus: ${node.hasPrimaryFocus}");
          //         // _handleFormFocus
          //         return KeyEventResult.handled;
          //       }),
          //       annotations: widget.dateAnnotation != null
          //           ? [
          //               Annotation(
          //                 range: widget.dateAnnotation!.range,
          //                 style: widget.dateAnnotation!.style,
          //               )
          //             ]
          //           : [],
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(children: [
              _buildDate(),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(children: [
              _buildPlatforms(),
            ]),
          ),
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

import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/data/user.dart';
import 'package:atlast_mobile_app/models/catalyst_model.dart';
import 'package:atlast_mobile_app/services/generator_service.dart';
import 'package:atlast_mobile_app/shared/animated_loading_dots.dart';
import 'package:atlast_mobile_app/shared/animated_text_blinking.dart';
import 'package:atlast_mobile_app/shared/app_bar_steps.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';
import 'package:atlast_mobile_app/shared/layouts/single_child_scroll_bare.dart';
import 'package:provider/provider.dart';

class CreatorSocialMediaPostResults extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;
  final CatalystBreakdown catalyst;

  const CreatorSocialMediaPostResults({
    Key? key,
    required this.navKey,
    required this.catalyst,
  }) : super(key: key);

  @override
  _CreatorSocialMediaPostResultsState createState() =>
      _CreatorSocialMediaPostResultsState();
}

class _CreatorSocialMediaPostResultsState
    extends State<CreatorSocialMediaPostResults> {
  bool _captionsLoaded = false;
  bool _captionsRegenerating = false;
  List<String> _captions = [];
  int _numCaptionGenerations = 0;

  // form variables
  final _formKey = GlobalKey<FormState>();

  void _handleBack() {
    widget.navKey.currentState!.pop();
  }

  void _handleContinue() {
    widget.navKey.currentState!.popUntil((Route r) => r.isFirst);
  }

  Future<void> _fetchCaptions(BuildContext ctx) async {
    if (_numCaptionGenerations == 0) {
      setState(() => _captionsLoaded = false);
    } else {
      setState(() => _captionsRegenerating = true);
    }

    final List<String> response = await GeneratorService.fetchCaptions(
      widget.catalyst.derivedPrompt,
      platform: widget.catalyst.derivedPlatforms[0].toString(),
      // voice: <>,
      userData: Provider.of<UserStore>(ctx, listen: false).data,
      generationNum: _numCaptionGenerations + 1,
      catalyst: widget.catalyst.catalyst,
    );
    // final List<String> test = response.map((e) => e.toString()).toList();
    setState(() {
      _captions = response;
      _captionsLoaded = true;
      _captionsRegenerating = false;
      _numCaptionGenerations += 1;
    });
  }

  @override
  void initState() {
    super.initState();

    _fetchCaptions(context);
  }

  Widget _buildLoadingAnims() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AnimatedLoadingDots(size: 75),
          AnimatedBlinkText(
            text: "Generating your captions",
            textStyle: AppText.bodyBold
                .merge(const TextStyle(color: AppColors.primary)),
            width: 200,
            duration: 800,
          )
        ],
      ),
    );
  }

  Widget _buildNoCaptions() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Prompt could not be found. Please retry.",
            style: AppText.heading
                .merge(const TextStyle(color: AppColors.primary)),
          )
        ],
      ),
    );
  }

  Widget _buildResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 400,
          child: _captionsRegenerating
              ? const Center(child: AnimatedLoadingDots(size: 75))
              : ListView.separated(
                  itemCount: _captions.length,
                  itemBuilder: (BuildContext ctx, int idx) =>
                      Text(_captions[idx], style: AppText.bodyBold),
                  separatorBuilder: (BuildContext ctx, int idx) =>
                      const Divider(),
                ),
        ),
        Center(
          child: CustomButton(
            handlePressed: () => _fetchCaptions(context),
            fillColor: AppColors.primary,
            text: 'Regenerate captions',
            disabled: _captionsRegenerating,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutFullPage(
      handleBack: _handleBack,
      appBarContent: const AppBarSteps(totalSteps: 3, currStep: 3),
      content: () {
        if (!_captionsLoaded) return _buildLoadingAnims();
        if (_captions.isEmpty) return _buildNoCaptions();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeroHeading(text: "Choose a Caption"),
            Expanded(
              child: SingleChildScrollBare(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _buildResults(),
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
        );
      }(),
    );
  }
}

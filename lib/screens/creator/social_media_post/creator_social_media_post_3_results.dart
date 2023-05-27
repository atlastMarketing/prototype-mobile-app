import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/data/user.dart';
import 'package:atlast_mobile_app/models/catalyst_model.dart';
import 'package:atlast_mobile_app/models/content_model.dart';
import 'package:atlast_mobile_app/services/generator_service.dart';
import 'package:atlast_mobile_app/shared/animated_loading_dots.dart';
import 'package:atlast_mobile_app/shared/animated_text_blinking.dart';
import 'package:atlast_mobile_app/shared/app_bar_steps.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';

class CreatorSocialMediaPostResults extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;
  final CatalystBreakdown catalyst;
  final String? uploadedImageUrl;
  final void Function(List<PostContent>) saveDraftPosts;

  const CreatorSocialMediaPostResults({
    Key? key,
    required this.navKey,
    required this.catalyst,
    required this.saveDraftPosts,
    this.uploadedImageUrl = "",
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

  int _selectedCaptionIdx = -1;

  void _handleBack() {
    widget.navKey.currentState!.pop();
  }

  void _handleContinue() {
    List<PostContent> posts = widget.catalyst.derivedPlatforms
        .toList()
        .map((platform) => PostContent(
              id: "new-single-post",
              platform: platform,
              dateTime: widget.catalyst.derivedPostTimestamps[0],
              caption: _captions[_selectedCaptionIdx],
              imageUrl: widget.uploadedImageUrl,
            ))
        .toList();
    widget.saveDraftPosts(posts);

    widget.navKey.currentState!.pushNamed("/post-confirm");
  }

  Future<void> _fetchCaptions(BuildContext ctx) async {
    if (_numCaptionGenerations == 0) {
      setState(() {
        _captionsLoaded = false;
        _selectedCaptionIdx = -1;
      });
    } else {
      setState(() {
        _captionsRegenerating = true;
        _selectedCaptionIdx = -1;
      });
    }

    final List<String> response = await GeneratorService.fetchCaptions(
      widget.catalyst.derivedPrompt,
      platform: widget.catalyst.derivedPlatforms[0].toString(),
      // voice: <>,
      userData: Provider.of<UserStore>(ctx, listen: false).data,
      generationNum: _numCaptionGenerations + 1,
      catalyst: widget.catalyst.catalyst,
      numOptions: 3,
    );
    // final List<String> test = response.map((e) => e.toString()).toList();
    setState(() {
      _captions = response;
      _captionsLoaded = true;
      _captionsRegenerating = false;
      _numCaptionGenerations += 1;
    });
  }

  void _handleSelectCaption(int idx) {
    setState(() => _selectedCaptionIdx = idx);
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
            "Sorry! No captions could be generated.",
            style: AppText.heading
                .merge(const TextStyle(color: AppColors.primary)),
          )
        ],
      ),
    );
  }

  Widget _buildCaptionButton(int optionIdx) {
    bool isActive = _selectedCaptionIdx == optionIdx;
    String caption = _captions[optionIdx];

    return SizedBox(
      height: 130,
      width: double.infinity,
      child: Material(
        color: isActive ? AppColors.secondary : AppColors.light,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _handleSelectCaption(optionIdx),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Text(
              caption,
              style: isActive ? AppText.whiteText : AppText.blackText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_captionsRegenerating) {
      return const Center(child: AnimatedLoadingDots(size: 75));
    }
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      itemCount: _captions.length,
      itemBuilder: (BuildContext ctx, int idx) => _buildCaptionButton(idx),
      separatorBuilder: (BuildContext ctx, int idx) => const Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutFullPage(
      handleBack: _handleBack,
      appBarContent: const AppBarSteps(totalSteps: 4, currStep: 3),
      content: () {
        if (!_captionsLoaded) return _buildLoadingAnims();
        if (_captions.isEmpty) return _buildNoCaptions();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeroHeading(text: "Choose a Caption"),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildResults(),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                handlePressed: () => _fetchCaptions(context),
                fillColor: AppColors.error,
                text: 'Regenerate captions',
                disabled: _captionsRegenerating,
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                disabled: _captionsRegenerating || _selectedCaptionIdx == -1,
                handlePressed: _handleContinue,
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

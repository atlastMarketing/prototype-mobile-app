import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/constants/stock_images.dart';
import 'package:atlast_mobile_app/constants/catalyst_output_types.dart';
import 'package:atlast_mobile_app/constants/social_media_platforms.dart';
import 'package:atlast_mobile_app/data/user.dart';
import 'package:atlast_mobile_app/models/catalyst_model.dart';
import 'package:atlast_mobile_app/models/content_model.dart';
import 'package:atlast_mobile_app/models/image_model.dart';
import 'package:atlast_mobile_app/services/generator_service.dart';
import 'package:atlast_mobile_app/shared/animated_loading_dots.dart';
import 'package:atlast_mobile_app/shared/animated_text_blinking.dart';
import 'package:atlast_mobile_app/shared/app_bar_steps.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/calendar.dart';
import 'package:atlast_mobile_app/shared/widget_overlays.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';

import './creator_campaign_single_post_edit.dart';

class CreatorCampaignSchedule extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;
  final CatalystBreakdown catalyst;
  final List<UploadedImage> images;
  final List<PostContent> draftPosts;
  final void Function(List<PostContent>) saveDraftPosts;

  const CreatorCampaignSchedule({
    Key? key,
    required this.navKey,
    required this.catalyst,
    required this.images,
    required this.draftPosts,
    required this.saveDraftPosts,
  }) : super(key: key);

  @override
  _CreatorCampaignScheduleState createState() =>
      _CreatorCampaignScheduleState();
}

class _CreatorCampaignScheduleState extends State<CreatorCampaignSchedule> {
  // state and status
  bool _campaignDatesFetched = false;
  bool _campaignDatesIsLoading = false;
  List<int> _campaignDates = [];
  int _numDateGenerations = 0;
  bool _captionsIsLoading = false;
  bool _campaignDatesApproved = false;

  // generated stuff
  List<String> _generatedCaptions = [];

  // misc
  final MAX_CAPTION_REQUESTS_AT_ONCE = 5;

  void _handleBack() {
    widget.navKey.currentState!.pop();
  }

  void _handleContinue() {
    widget.navKey.currentState!.pushNamed("/campaign-confirm");
  }

  Future<void> _fetchCampaignDates() async {
    setState(() => _campaignDatesIsLoading = true);

    late List<int> response;

    switch (widget.catalyst.campaignOutputType) {
      case CatalystCampaignOutputTypes.daily:
        {
          response = await GeneratorService.fetchRegularCampaignDates(
            widget.catalyst.derivedPrompt,
            widget.catalyst.derivedStartTimestamp ??
                DateTime.now().millisecondsSinceEpoch,
            widget.catalyst.campaignOutputType!,
            endDate: widget.catalyst.derivedEndTimestamp,
            platform: widget.catalyst.derivedPlatforms[0].toString(),
            // voice: <>,
            userData: Provider.of<UserStore>(context, listen: false).data,
            generationNum: _numDateGenerations + 1,
            catalyst: widget.catalyst.catalyst,
            maxPosts: widget.catalyst.maximumPosts,
          );
        }
        break;

      case CatalystCampaignOutputTypes.monthly:
        {
          response = await GeneratorService.fetchRegularCampaignDates(
            widget.catalyst.derivedPrompt,
            widget.catalyst.derivedStartTimestamp ??
                DateTime.now().millisecondsSinceEpoch,
            widget.catalyst.campaignOutputType!,
            endDate: widget.catalyst.derivedEndTimestamp,
            platform: widget.catalyst.derivedPlatforms[0].toString(),
            // voice: <>,
            userData: Provider.of<UserStore>(context, listen: false).data,
            generationNum: _numDateGenerations + 1,
            catalyst: widget.catalyst.catalyst,
            maxPosts: widget.catalyst.maximumPosts,
          );
        }
        break;

      case CatalystCampaignOutputTypes.weekly:
        {
          response = await GeneratorService.fetchRegularCampaignDates(
            widget.catalyst.derivedPrompt,
            widget.catalyst.derivedStartTimestamp ??
                DateTime.now().millisecondsSinceEpoch,
            widget.catalyst.campaignOutputType!,
            endDate: widget.catalyst.derivedEndTimestamp,
            platform: widget.catalyst.derivedPlatforms[0].toString(),
            // voice: <>,
            userData: Provider.of<UserStore>(context, listen: false).data,
            generationNum: _numDateGenerations + 1,
            catalyst: widget.catalyst.catalyst,
            maxPosts: widget.catalyst.maximumPosts,
          );
        }
        break;

      default:
        {
          response = await GeneratorService.fetchIrregularCampaignDates(
            widget.catalyst.derivedPrompt,
            widget.catalyst.derivedStartTimestamp ??
                DateTime.now().millisecondsSinceEpoch,
            widget.catalyst.campaignOutputType ??
                CatalystCampaignOutputTypes.event,
            endDate: widget.catalyst.derivedEndTimestamp,
            platform: widget.catalyst.derivedPlatforms[0].toString(),
            // voice: <>,
            userData: Provider.of<UserStore>(context, listen: false).data,
            generationNum: _numDateGenerations + 1,
            catalyst: widget.catalyst.catalyst,
            maxPosts: widget.catalyst.maximumPosts,
          );
        }
        break;
    }

    // TODO: get real images
    List<String> listOfImageUrls = [
      ...widget.images.map((i) => i.imageUrl).toList(),
      ...stockImages
    ];

    setState(() {
      _campaignDates = response;
      _campaignDatesFetched = true;
      _campaignDatesIsLoading = false;
      _numDateGenerations += 1;
    });

    List<PostContent> drafts = response
        .asMap()
        .entries
        .map(
          (e) => PostContent(
            id: e.key.toString(),
            dateTime: e.value,
            caption: "",
            platform: widget.catalyst.derivedPlatforms[0],
            imageUrl:
                listOfImageUrls[Random().nextInt(listOfImageUrls.length - 1)],
          ),
        )
        .toList();

    widget.saveDraftPosts(drafts);
  }

  Future<void> _fetchCaptionsForCampaign({
    SocialMediaPlatforms? platform,
    required int numCaptions,
  }) async {
    setState(() => _captionsIsLoading = true);

    SocialMediaPlatforms p = platform ?? widget.catalyst.derivedPlatforms[0];
    final List<String> response = await GeneratorService.fetchCaptions(
      widget.catalyst.derivedPrompt,
      platform: p.toString(),
      // voice: <>,
      userData: Provider.of<UserStore>(context, listen: false).data,
      generationNum: 0,
      catalyst: widget.catalyst.catalyst,
      // TODO: remove this cap
      numOptions: min(MAX_CAPTION_REQUESTS_AT_ONCE, numCaptions),
    );

    setState(() {
      _captionsIsLoading = false;
      _generatedCaptions = response;
    });

    List<PostContent> newPosts = widget.draftPosts;
    for (var i = 0; i < widget.draftPosts.length; i++) {
      newPosts[i].caption = response[i % response.length];
    }
    widget.saveDraftPosts(newPosts);
  }

  void _approveCampaignDates() async {
    await _fetchCaptionsForCampaign(numCaptions: widget.draftPosts.length);
    setState(() => _campaignDatesApproved = true);
  }

  void _saveDraftPost(String postId, PostContent newContent) {
    int postIdDraft = int.parse(postId);
    List<PostContent> newPosts = widget.draftPosts;
    newPosts[postIdDraft] = newContent;
    widget.saveDraftPosts(newPosts);
  }

  void _openEditSinglePost(String postId) {
    if (!_campaignDatesApproved) return;

    int postIdDraft = int.parse(postId);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreatorCampaignSinglePostEdit(
          navKey: widget.navKey,
          postContent: widget.draftPosts[postIdDraft],
          saveChanges: _saveDraftPost,
          prompt: widget.catalyst.derivedPrompt,
          initialCaptions: _generatedCaptions,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _fetchCampaignDates();
  }

  Widget _buildLoadingAnims() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AnimatedLoadingDots(size: 75),
          AnimatedBlinkText(
            text: "Generating your campaign",
            textStyle: AppText.bodyBold
                .merge(const TextStyle(color: AppColors.primary)),
            width: 200,
            duration: 800,
          )
        ],
      ),
    );
  }

  Widget _buildNoCampaignDates() {
    return Center(
      child: Text(
        "Dates could not be generated. Please retry.",
        style: AppText.heading.merge(const TextStyle(color: AppColors.primary)),
      ),
    );
  }

  Widget _buildRegenerationAndApprovalButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            disabled: _captionsIsLoading,
            handlePressed: _fetchCampaignDates,
            fillColor: AppColors.error,
            text: 'Regenerate Campaign',
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 10)),
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            disabled: _captionsIsLoading,
            handlePressed: _approveCampaignDates,
            fillColor: AppColors.primary,
            text: 'Use Campaign',
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
        if (!_campaignDatesFetched) return _buildLoadingAnims();

        return _campaignDates.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeroHeading(text: "Posting Schedule"),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: WidgetOverlays(
                        disabled: !_campaignDatesApproved,
                        loading: _campaignDatesIsLoading || _captionsIsLoading,
                        child: CustomCalendar(
                          disableSelection: true,
                          initialPosts: widget.draftPosts,
                          handleTap: _openEditSinglePost,
                        ),
                      ),
                    ),
                  ),
                  _campaignDatesApproved
                      ? SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            handlePressed: _handleContinue,
                            fillColor: AppColors.primary,
                            text: 'Schedule Campaign',
                          ),
                        )
                      : _buildRegenerationAndApprovalButtons(),
                ],
              )
            : _buildNoCampaignDates();
      }(),
    );
  }
}

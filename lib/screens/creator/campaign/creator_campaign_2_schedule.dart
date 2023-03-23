import 'package:atlast_mobile_app/constants/catalyst_output_types.dart';
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
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreatorCampaignSchedule extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;
  final CatalystBreakdown catalyst;

  const CreatorCampaignSchedule({
    Key? key,
    required this.navKey,
    required this.catalyst,
  }) : super(key: key);

  @override
  _CreatorCampaignScheduleState createState() =>
      _CreatorCampaignScheduleState();
}

class _CreatorCampaignScheduleState extends State<CreatorCampaignSchedule> {
  bool _campaignDatesLoaded = false;
  bool _campaignDatesRegenerating = false;
  List<int> _campaignDates = [];
  int _numDateGenerations = 0;

  bool _captionsLoaded = false;
  bool _captionsRegenerating = false;
  List<String> _captions = [];
  int _numCaptionGenerations = 0;

  void _handleBack() {
    widget.navKey.currentState!.pop();
  }

  void _handleContinue() {
    widget.navKey.currentState!.pushNamed("/campaign-3");
  }

  Future<void> _fetchCampaignDates(BuildContext ctx) async {
    if (_numDateGenerations == 0) {
      setState(() => _campaignDatesLoaded = false);
    } else {
      setState(() => _campaignDatesRegenerating = true);
    }

    late List<int> response;

    switch (widget.catalyst.campaignOutputType) {
      case CatalystCampaignOutputTypes.daily:
        {
          response = await GeneratorService.fetchRegularCampaignDates(
            widget.catalyst.derivedPrompt,
            widget.catalyst.derivedStartTimestamp ??
                DateTime.now().millisecondsSinceEpoch,
            endDate: widget.catalyst.derivedEndTimestamp,
            platform: widget.catalyst.derivedPlatforms[0].toString(),
            // voice: <>,
            userData: Provider.of<UserStore>(ctx, listen: false).data,
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
            endDate: widget.catalyst.derivedEndTimestamp,
            platform: widget.catalyst.derivedPlatforms[0].toString(),
            // voice: <>,
            userData: Provider.of<UserStore>(ctx, listen: false).data,
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
            endDate: widget.catalyst.derivedEndTimestamp,
            platform: widget.catalyst.derivedPlatforms[0].toString(),
            // voice: <>,
            userData: Provider.of<UserStore>(ctx, listen: false).data,
            generationNum: _numDateGenerations + 1,
            catalyst: widget.catalyst.catalyst,
            maxPosts: widget.catalyst.maximumPosts,
          );
        }
        break;

      default:
        {
          response = await GeneratorService.fetchRegularCampaignDates(
            widget.catalyst.derivedPrompt,
            widget.catalyst.derivedStartTimestamp ??
                DateTime.now().millisecondsSinceEpoch,
            endDate: widget.catalyst.derivedEndTimestamp,
            platform: widget.catalyst.derivedPlatforms[0].toString(),
            // voice: <>,
            userData: Provider.of<UserStore>(ctx, listen: false).data,
            generationNum: _numDateGenerations + 1,
            catalyst: widget.catalyst.catalyst,
            maxPosts: widget.catalyst.maximumPosts,
          );
        }
        break;
    }

    setState(() {
      _campaignDates = response;
      _campaignDatesLoaded = true;
      _campaignDatesRegenerating = false;
      _numDateGenerations += 1;
    });
  }

  Future<void> _fetchCaptions(BuildContext ctx) async {
    if (_numCaptionGenerations == 0) {
      setState(() => _captionsLoaded = false);
    } else {
      setState(() => _captionsRegenerating = true);
    }

    final response = await GeneratorService.fetchCaptions(
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

    _fetchCampaignDates(context);
    // _fetchCaptions(context);
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

  Widget _buildResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _campaignDates.isEmpty
            ? _buildNoCampaignDates()
            : SizedBox(
                height: 400,
                child: _campaignDatesRegenerating
                    ? const Center(child: AnimatedLoadingDots(size: 75))
                    : ListView.separated(
                        physics: const ClampingScrollPhysics(),
                        itemCount: _campaignDates.length,
                        itemBuilder: (BuildContext ctx, int idx) {
                          DateTime date = DateTime.fromMillisecondsSinceEpoch(
                              _campaignDates[idx]);
                          return Text(
                            "${DateFormat.yMMMMd().format(date)} ${DateFormat.jms().format(date)}",
                            style: AppText.bodyBold,
                          );
                        },
                        separatorBuilder: (BuildContext ctx, int idx) =>
                            const Divider(),
                      ),
              ),
        Center(
          child: CustomButton(
            handlePressed: () => _fetchCampaignDates(context),
            fillColor: AppColors.primary,
            text: 'Regenerate dates',
            disabled: _campaignDatesRegenerating,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutFullPage(
      handleBack: _handleBack,
      appBarContent: const AppBarSteps(totalSteps: 4, currStep: 2),
      content: () {
        if (!_captionsLoaded && !_campaignDatesLoaded) {
          return _buildLoadingAnims();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeroHeading(text: "Posting Schedule"),
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
                handlePressed: _handleContinue,
                fillColor: AppColors.primary,
                text: 'Schedule Campaign',
              ),
            ),
          ],
        );
      }(),
    );
  }
}

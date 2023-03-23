import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:google_mlkit_entity_extraction/google_mlkit_entity_extraction.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/constants/catalyst_output_types.dart';
import 'package:atlast_mobile_app/constants/social_media_platforms.dart';
import 'package:atlast_mobile_app/constants/unique_char.dart';
import 'package:atlast_mobile_app/models/catalyst_model.dart';
import 'package:atlast_mobile_app/shared/annotated_text_field.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';
import 'package:atlast_mobile_app/shared/sample_page.dart';
import 'package:atlast_mobile_app/utils/ner_regex.dart';

import 'campaign/creator_campaign_1_catalyst.dart';
import 'campaign/creator_campaign_2_media.dart';
import 'campaign/creator_campaign_2_schedule.dart';
import 'social_media_post/creator_social_media_post_1_prompt.dart';
import 'social_media_post/creator_social_media_post_3_results.dart';

class Creator extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;

  const Creator({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  @override
  _CreatorState createState() => _CreatorState();
}

class _CreatorState extends State<Creator> {
  late CatalystBreakdown _catalystDetails;
  List<DateAnnotation> _dateAnnotations = [];
  List<SocialMediaPlatformAnnotation> _socialMediaPlatformAnnotations = [];

  // TODO: break down prompt details
  int _selectedCreatorOptionIdx = -1;

  final entityExtractor =
      EntityExtractor(language: EntityExtractorLanguage.english);

  _exitCreator() {
    Navigator.of(context).pop();
  }

  _handleInitialContinue() {
    if (_selectedCreatorOptionIdx == 0) {
      setState(() => _catalystDetails = CatalystBreakdown(
            catalyst: "",
            derivedPrompt: "",
            derivedOutputType: CatalystOutputTypes.singlePost,
          ));
      // create post
      widget.navKey.currentState!.pushNamed("/post-1");
    } else if (_selectedCreatorOptionIdx == 1) {
      setState(() => _catalystDetails = CatalystBreakdown(
            catalyst: "",
            derivedPrompt: "",
            derivedOutputType: CatalystOutputTypes.campaign,
            campaignOutputType: CatalystCampaignOutputTypes.event,
          ));
      // create campaign
      widget.navKey.currentState!.pushNamed("/campaign-1");
    } else if (_selectedCreatorOptionIdx == 2) {
      // create ad
      widget.navKey.currentState!.pushNamed("/ad-1");
    }
  }

  void _selectCreatorOption(int optionIdx) {
    setState(() => _selectedCreatorOptionIdx = optionIdx);
  }

  Future<void> _analyzeCatalyst(
    String catalyst, {
    CatalystOutputTypes type = CatalystOutputTypes.singlePost,
  }) async {
    // ------
    // ANNOTATION EXTRACTION
    // ------
    final List<EntityAnnotation> annotations =
        await entityExtractor.annotateText(
      catalyst,
      // TODO: don't hardcode these params
      // preferredLocale: 'en-US',
      referenceTimeZone: 'America/Vancouver',
    );

    final List<NERRegexRangeSocialMediaPlatform> matchedPlatforms =
        extractSocialMediaPlatformsFromCatalyst(catalyst);

    // ------
    // DATA MANIPULATION OF MANUAL NER
    // ------
    String __derivedPrompt = catalyst;
    List<SocialMediaPlatforms> __derivedPlatforms = [];
    List<int> __postTimestamps = [];
    int? __startTimestamp;
    int? __endTimestamp;
    List<DateAnnotation> __dateAnnotations = [];
    List<SocialMediaPlatformAnnotation> __socialMediaPlatformAnnotations = [];

    for (NERRegexRangeSocialMediaPlatform match in matchedPlatforms) {
      __derivedPrompt = __derivedPrompt.replaceRange(
          match.start, match.end, UNIQUE_CHAR * match.matched.length);

      __derivedPlatforms.add(match.platform);
      __socialMediaPlatformAnnotations.add(SocialMediaPlatformAnnotation(
        range: TextRange(
          start: match.start,
          end: match.end,
        ),
        platform: match.platform,
        style: AppText.bodyBold.merge(const TextStyle(
          backgroundColor: AppColors.customize,
        )),
      ));
    }

    // ------
    // FURTHER DATA MANIPULATION OF GOOGLE NER
    // ------
    if (annotations.isNotEmpty) {
      final List<EntityAnnotation> annotatedDates = annotations
          .where(
            (ant) => ant.entities
                .where((ent) => ent.type == EntityType.dateTime)
                .isNotEmpty,
          )
          .toList();

      for (EntityAnnotation annotatedDate in annotatedDates) {
        DateTimeEntity ent = annotatedDate.entities
            .firstWhere((e) => e.type == EntityType.dateTime) as DateTimeEntity;
        // skip if date selected is before today
        if (DateTime.fromMillisecondsSinceEpoch(ent.timestamp * 1000)
            .isBefore(DateTime.now())) continue;

        final NERRegexRangeDate _extractedDate = extractDateBuffersFromCatalyst(
          catalyst,
          annotatedDate.start,
          annotatedDate.end,
          ent,
        );

        __derivedPrompt = __derivedPrompt.replaceRange(_extractedDate.start,
            _extractedDate.end, UNIQUE_CHAR * _extractedDate.matched.length);

        __dateAnnotations.add(DateAnnotation(
          range: TextRange(
            start: _extractedDate.start + 1,
            end: _extractedDate.end,
          ),
          timestamp: _extractedDate.timestamp,
          style: AppText.bodyBold.merge(const TextStyle(
            backgroundColor: AppColors.confirm,
          )),
        ));

        if (type == CatalystOutputTypes.singlePost) {
          __postTimestamps.add(_extractedDate.timestamp);
          break;
        } else if (type == CatalystOutputTypes.campaign) {
          if (__startTimestamp == null && __endTimestamp == null) {
            if (_extractedDate.matched.contains('from')) {
              __startTimestamp = _extractedDate.timestamp;
            } else {
              __endTimestamp = _extractedDate.timestamp;
            }
          } else if (__startTimestamp == null && __endTimestamp != null) {
            __startTimestamp = _extractedDate.timestamp < __endTimestamp
                ? _extractedDate.timestamp
                : __endTimestamp;
            __endTimestamp = _extractedDate.timestamp < __endTimestamp
                ? __endTimestamp
                : _extractedDate.timestamp;
            break;
          } else if (__startTimestamp != null && __endTimestamp == null) {
            __endTimestamp = _extractedDate.timestamp >= __startTimestamp
                ? _extractedDate.timestamp
                : __startTimestamp;
            __startTimestamp = _extractedDate.timestamp >= __startTimestamp
                ? __startTimestamp
                : _extractedDate.timestamp;
            break;
          }
        }
      }
    }

    // ------
    // SAVING
    // ------
    setState(() {
      _catalystDetails.catalyst = catalyst;
      _catalystDetails.derivedPrompt =
          __derivedPrompt.replaceAll(UNIQUE_CHAR, "").trim();
      _catalystDetails.derivedPostTimestamps = __postTimestamps;
      _catalystDetails.derivedStartTimestamp = __startTimestamp;
      _catalystDetails.derivedEndTimestamp = __endTimestamp;
      // remove hardcoding here
      _catalystDetails.derivedPlatforms = __derivedPlatforms;
      _dateAnnotations = __dateAnnotations;
      _socialMediaPlatformAnnotations = __socialMediaPlatformAnnotations;
    });
  }

  void _updateCatalyst({
    List<int>? postTimestamps,
    int? startTimestamp,
    int? endTimestamp,
    List<SocialMediaPlatforms>? platforms,
    CatalystCampaignOutputTypes? campaignType,
    int? maximumPosts,
  }) {
    if (postTimestamps != null) {
      _dateAnnotations = [];
      _catalystDetails.derivedPostTimestamps = postTimestamps;
    }
    if (startTimestamp != null || endTimestamp != null) {
      _dateAnnotations = [];
      _catalystDetails.derivedStartTimestamp =
          startTimestamp ?? _catalystDetails.derivedStartTimestamp;
      _catalystDetails.derivedEndTimestamp =
          endTimestamp ?? _catalystDetails.derivedEndTimestamp;
    }
    if (platforms != null) {
      _socialMediaPlatformAnnotations = [];
      _catalystDetails.derivedPlatforms = platforms;
    }
    if (campaignType != null) {
      _catalystDetails.campaignOutputType = campaignType;
    }
    if (maximumPosts != null) {
      _catalystDetails.maximumPosts = maximumPosts;
    }
    setState(() {});
  }

  Widget _buildCreatorOptionButton(
    String title,
    String description,
    IconData iconData,
    int optionIdx,
  ) {
    final bool isActive = _selectedCreatorOptionIdx == optionIdx;
    return SizedBox(
      height: 130,
      width: double.infinity,
      child: Material(
        color: isActive ? AppColors.secondary : AppColors.light,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _selectCreatorOption(optionIdx),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      iconData,
                      size: 30,
                      color: isActive ? AppColors.white : AppColors.black,
                    ),
                    const Padding(padding: EdgeInsets.only(right: 10)),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppText.buttonLargeText.merge(
                              isActive ? AppText.whiteText : AppText.blackText,
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(bottom: 5)),
                          Text(
                            description,
                            style: isActive
                                ? AppText.whiteText
                                : AppText.blackText,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreatorOptions() {
    return LayoutFullPage(
      squeezeContents: false,
      handleBack: _exitCreator,
      content: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const HeroHeading(text: "What would you like\nto create?"),
                _buildCreatorOptionButton(
                  "Create a Post",
                  "This generates a single post. Good for one time promotions.",
                  Icons.campaign,
                  0,
                ),
                const Padding(padding: EdgeInsets.only(bottom: 20)),
                _buildCreatorOptionButton(
                  "Create a Campaign",
                  "This generates and schedules multiple posts belonging to the same campaign.",
                  Icons.insert_invitation,
                  1,
                ),
                const Padding(padding: EdgeInsets.only(bottom: 20)),
                _buildCreatorOptionButton(
                  "Create an Ad",
                  "Reach more customers with precise targeting and actionable insights.",
                  Icons.ads_click,
                  2,
                ),
                const Spacer(),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              disabled: _selectedCreatorOptionIdx < 0 ||
                  _selectedCreatorOptionIdx > 2,
              text: 'Continue',
              handlePressed: _handleInitialContinue,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // lazy loading
    return WillPopScope(
      onWillPop: () async {
        if (widget.navKey.currentState!.canPop()) {
          widget.navKey.currentState!.pop();
          return false;
        }

        return true;
      },
      child: Scaffold(
        body: Navigator(
          key: widget.navKey,
          initialRoute: '/',
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) {
                switch (settings.name) {
                  case "/post-1":
                    return CreatorSocialMediaPostPrompt(
                      navKey: widget.navKey,
                      analyzeCatalyst: _analyzeCatalyst,
                      updateCatalyst: _updateCatalyst,
                      catalyst: _catalystDetails,
                      dateAnnotation: _dateAnnotations.firstOrNull,
                      socialMediaPlatformAnnotation:
                          _socialMediaPlatformAnnotations.firstOrNull,
                    );
                  case "/post-results":
                    return CreatorSocialMediaPostResults(
                      navKey: widget.navKey,
                      catalyst: _catalystDetails,
                    );
                  case "/campaign-1":
                    return CreatorCampaignCatalyst(
                      navKey: widget.navKey,
                      analyzeCatalyst: _analyzeCatalyst,
                      updateCatalyst: _updateCatalyst,
                      catalyst: _catalystDetails,
                      dateAnnotations: _dateAnnotations,
                      socialMediaPlatformAnnotations:
                          _socialMediaPlatformAnnotations,
                    );
                  case "/campaign-2":
                    return CreatorCampaignSchedule(
                      navKey: widget.navKey,
                      catalyst: _catalystDetails,
                    );
                  case "/campaign-3":
                    return CreatorCampaignMedia(
                      navKey: widget.navKey,
                    );
                  case "/ad-1":
                    return const SamplePage();
                  default:
                    return _buildCreatorOptions();
                }
              },
            );
          },
        ),
        extendBody: false,
      ),
    );
  }
}

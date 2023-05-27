import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:google_mlkit_entity_extraction/google_mlkit_entity_extraction.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/constants/catalyst_output_types.dart';
import 'package:atlast_mobile_app/constants/social_media_platforms.dart';
import 'package:atlast_mobile_app/constants/unique_char.dart';
import 'package:atlast_mobile_app/models/annotations_model.dart';
import 'package:atlast_mobile_app/models/catalyst_model.dart';
import 'package:atlast_mobile_app/models/content_model.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/models/image_model.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';
import 'package:atlast_mobile_app/shared/sample_page.dart';
import 'package:atlast_mobile_app/shared/help_popup.dart';
import 'package:atlast_mobile_app/utils/ner_regex.dart';

import 'campaign/creator_campaign_1_catalyst.dart';
import 'campaign/creator_campaign_2_images.dart';
import 'campaign/creator_campaign_3_schedule.dart';
import 'campaign/creator_campaign_confirm.dart';
import 'social_media_post/creator_social_media_post_1_catalyst.dart';
import 'social_media_post/creator_social_media_post_2_image.dart';
import 'social_media_post/creator_social_media_post_3_results.dart';
// import 'social_media_post/creator_social_media_post_4_schedule.dart';
import 'social_media_post/creator_social_media_post_confirm.dart';

class Creator extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;

  const Creator({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  @override
  _CreatorState createState() => _CreatorState();
}

// ignore: constant_identifier_names
const DEFAULT_CAMPAIGN_OUTPUT_TYPE = CatalystCampaignOutputTypes.daily;

class _CreatorState extends State<Creator> {
  final entityExtractor =
      EntityExtractor(language: EntityExtractorLanguage.english);

  // ------
  // STATES
  // ------

  // navigations states
  int _selectedCreatorOptionIdx = -1;

  // prompt analysis
  late CatalystBreakdown _catalystDetails;
  List<UploadedImage> _uploadedImages = [];
  // prompt analysis - annotations
  List<DateAnnotation> _dateAnnotations = [];
  List<SocialMediaPlatformAnnotation> _socialMediaPlatformAnnotations = [];
  List<CampaignOutputTypeAnnotation> _campaignOutputTypeAnnotations = [];
  List<PostContent> _draftPosts = [];

  // ------
  // NAVIGATION FUNCTIONS
  // ------

  void _exitCreator() {
    Navigator.of(context).pop();
  }

  void _handleInitialContinue() {
    if (_selectedCreatorOptionIdx == 0) {
      setState(() {
        _catalystDetails = CatalystBreakdown(
          catalyst: "",
          derivedPrompt: "",
          derivedOutputType: CatalystOutputTypes.singlePost,
        );
        _selectedCreatorOptionIdx = -1;
      });
      // create post
      widget.navKey.currentState!.pushNamed("/post-1");
    } else if (_selectedCreatorOptionIdx == 1) {
      setState(() {
        _catalystDetails = CatalystBreakdown(
          catalyst: "",
          derivedPrompt: "",
          derivedOutputType: CatalystOutputTypes.campaign,
          campaignOutputType: CatalystCampaignOutputTypes.daily,
        );
        _selectedCreatorOptionIdx = -1;
      });
      // create campaign
      widget.navKey.currentState!.pushNamed("/campaign-1");
    } else if (_selectedCreatorOptionIdx == 2) {
      // create ad
      setState(() {
        _selectedCreatorOptionIdx = -1;
      });
      widget.navKey.currentState!.pushNamed("/ad-1");
    }
  }

  void _selectCreatorOption(int optionIdx) {
    setState(() => _selectedCreatorOptionIdx = optionIdx);
  }

  // ------
  // CATALYST ANALYZERS
  // ------

  Future<void> _analyzeCatalyst(
    String catalyst, {
    CatalystOutputTypes type = CatalystOutputTypes.singlePost,
  }) async {
    // MANUAL NER
    String __derivedPrompt = catalyst;
    List<SocialMediaPlatforms> __derivedPlatforms = [];
    CatalystCampaignOutputTypes __campaignOutputType =
        _catalystDetails.campaignOutputType ?? DEFAULT_CAMPAIGN_OUTPUT_TYPE;
    List<SocialMediaPlatformAnnotation> __socialMediaPlatformAnnotations = [];
    List<CampaignOutputTypeAnnotation> __campaignOutputTypeAnnotations = [];

    if (type == CatalystOutputTypes.campaign) {
      final NERRegexRangeCampaignOutputType? matchedCampaignOutputType =
          extractCampaignOutputTypeFromCatalyst(catalyst);
      __campaignOutputType =
          matchedCampaignOutputType?.campaignOutputType ?? __campaignOutputType;

      if (matchedCampaignOutputType != null) {
        __campaignOutputTypeAnnotations.add(CampaignOutputTypeAnnotation(
          range: TextRange(
            start: matchedCampaignOutputType.start,
            end: matchedCampaignOutputType.end,
          ),
          campaignOutputType: matchedCampaignOutputType,
          style: AppText.bodyBold.merge(const TextStyle(
            backgroundColor: AppColors.error,
          )),
        ));
        __derivedPrompt = __derivedPrompt.replaceRange(
          matchedCampaignOutputType.start,
          matchedCampaignOutputType.end,
          UNIQUE_CHAR * matchedCampaignOutputType.matched.length,
        );
      }
    }

    final List<NERRegexRangeSocialMediaPlatform> matchedPlatforms =
        extractSocialMediaPlatformsFromCatalyst(catalyst);

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

    // AUTOMATIC ANNOTATION EXTRACTION (GOOGLE NER)
    List<int> __postTimestamps = [];
    int? __startTimestamp;
    int? __endTimestamp;
    List<DateAnnotation> __dateAnnotations = [];

    final List<EntityAnnotation> annotations =
        await entityExtractor.annotateText(
      catalyst,
      // TODO: don't hardcode these params
      // preferredLocale: 'en-US',
      referenceTimeZone: 'America/Vancouver',
    );

    // DATA MANIPULATION OF GOOGLE NER
    if (annotations.isNotEmpty) {
      print("ANOT!");
      print(annotations);
      final List<EntityAnnotation> annotatedDates = annotations
          .where(
            (ant) => ant.entities
                .where((ent) => ent.type == EntityType.dateTime)
                .isNotEmpty,
          )
          .toList();

      DateTime lastMidnight = DateTime.now();
      lastMidnight =
          DateTime(lastMidnight.year, lastMidnight.month, lastMidnight.day);

      for (EntityAnnotation annotatedDate in annotatedDates) {
        DateTimeEntity ent = annotatedDate.entities
            .firstWhere((e) => e.type == EntityType.dateTime) as DateTimeEntity;
        final timestamp = castToMilliseconds(ent.timestamp);
        // skip if date selected is before today
        if (DateTime.fromMillisecondsSinceEpoch(timestamp)
            .isBefore(lastMidnight)) continue;

        final NERRegexRangeDate _extractedDate = extractDateBuffersFromCatalyst(
          catalyst,
          annotatedDate.start,
          annotatedDate.end,
          timestamp,
        );

        __derivedPrompt = __derivedPrompt.replaceRange(_extractedDate.start,
            _extractedDate.end, UNIQUE_CHAR * _extractedDate.matched.length);

        __dateAnnotations.add(DateAnnotation(
          range: TextRange(
            start: _extractedDate.start,
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
            if (isStartingDate(_extractedDate.matched)) {
              __startTimestamp = _extractedDate.timestamp;
            } else if (isEndingDate(_extractedDate.matched)) {
              __endTimestamp = _extractedDate.timestamp;
            } else if (__campaignOutputType ==
                CatalystCampaignOutputTypes.event) {
              __endTimestamp = _extractedDate.timestamp;
            } else {
              __startTimestamp = _extractedDate.timestamp;
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

    // SAVING
    setState(() {
      _catalystDetails.catalyst = catalyst;
      _catalystDetails.derivedPrompt =
          __derivedPrompt.replaceAll(UNIQUE_CHAR, "").trim();
      _catalystDetails.derivedPostTimestamps = __postTimestamps;
      _catalystDetails.derivedStartTimestamp = __startTimestamp;
      _catalystDetails.derivedEndTimestamp = __endTimestamp;
      // remove hardcoding here
      _catalystDetails.derivedPlatforms = __derivedPlatforms;
      _catalystDetails.campaignOutputType = __campaignOutputType;
      _dateAnnotations = __dateAnnotations;
      _socialMediaPlatformAnnotations = __socialMediaPlatformAnnotations;
      _campaignOutputTypeAnnotations = __campaignOutputTypeAnnotations;
    });
  }

  void _updateCatalyst({
    List<int>? postTimestamps,
    int? startTimestamp,
    int? endTimestamp,
    List<SocialMediaPlatforms>? platforms,
    CatalystCampaignOutputTypes? campaignOutputType,
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
    if (campaignOutputType != null) {
      _campaignOutputTypeAnnotations = [];
      _catalystDetails.campaignOutputType = campaignOutputType;
    }
    if (maximumPosts != null) {
      _catalystDetails.maximumPosts = maximumPosts;
    }
    setState(() {});
  }

  List<Annotation> _compileAnnotations() {
    List<Annotation> textAnnotations = [];

    textAnnotations.addAll(_dateAnnotations.map(
      (annot) => Annotation(
        range: annot.range,
        style: annot.style,
      ),
    ));
    textAnnotations.addAll(_socialMediaPlatformAnnotations.map(
      (annot) => Annotation(
        range: annot.range,
        style: annot.style,
      ),
    ));
    textAnnotations.addAll(_campaignOutputTypeAnnotations.map(
      (annot) => Annotation(
        range: annot.range,
        style: annot.style,
      ),
    ));

    return textAnnotations;
  }

  void _saveUploadedImages(List<UploadedImage> images) {
    setState(() => _uploadedImages = images);
  }

  void _saveDraftPosts(List<PostContent> newPosts) {
    setState(() => _draftPosts = newPosts);
  }

  // ------
  // WIDGET BUILDERS
  // ------

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
              HelpPopup(
                title: "Hello!",
                content:
                    "I am your AI Marketing Assistant. I am here to help you use our app to create your social media posts. The more you use this app, the more I learn how to market your business!",
                highlight: false,
                child: _buildCreatorOptionButton(
                  "Create a Campaign",
                  "This generates and schedules multiple posts belonging to the same campaign.",
                  Icons.insert_invitation,
                  1,
                ),
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
          )),
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

  // ------
  // BUILD
  // ------

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
      child: Navigator(
        key: widget.navKey,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              switch (settings.name) {
                case "/post-1":
                  return CreatorSocialMediaPostCatalyst(
                    navKey: widget.navKey,
                    analyzeCatalyst: _analyzeCatalyst,
                    updateCatalyst: _updateCatalyst,
                    catalyst: _catalystDetails,
                    dateAnnotation: _dateAnnotations.firstOrNull,
                    socialMediaPlatformAnnotations:
                        _socialMediaPlatformAnnotations,
                  );
                case "/post-2":
                  return CreatorSocialMediaPostImage(
                    navKey: widget.navKey,
                    uploadedImage:
                        _uploadedImages.isNotEmpty ? _uploadedImages[0] : null,
                    saveImages: _saveUploadedImages,
                  );
                // case "/post-3":
                //   return CreatorSocialMediaPostSchedule(
                //     navKey: widget.navKey,
                //     catalyst: _catalystDetails,
                //     images: _uploadedImages,
                //     draftPosts: _draftPosts,
                //     saveDraftPosts: _saveDraftPosts,
                //   );
                case "/post-3":
                  return CreatorSocialMediaPostResults(
                    navKey: widget.navKey,
                    catalyst: _catalystDetails,
                    uploadedImageUrl: _uploadedImages.isNotEmpty
                        ? _uploadedImages[0].imageUrl
                        : null,
                    saveDraftPosts: _saveDraftPosts,
                  );
                case "/post-confirm":
                  return CreatorSocialMediaPostConfirm(
                    navKey: widget.navKey,
                    draftPosts: _draftPosts,
                    exit: _exitCreator,
                  );
                case "/campaign-1":
                  List<Annotation> textAnnotations = _compileAnnotations();
                  return CreatorCampaignCatalyst(
                    navKey: widget.navKey,
                    analyzeCatalyst: _analyzeCatalyst,
                    updateCatalyst: _updateCatalyst,
                    catalyst: _catalystDetails,
                    annotations: textAnnotations,
                  );
                case "/campaign-2":
                  return CreatorCampaignImages(
                    navKey: widget.navKey,
                    images: _uploadedImages,
                    saveImages: _saveUploadedImages,
                  );
                case "/campaign-3":
                  return CreatorCampaignSchedule(
                    navKey: widget.navKey,
                    catalyst: _catalystDetails,
                    images: _uploadedImages,
                    draftPosts: _draftPosts,
                    saveDraftPosts: _saveDraftPosts,
                  );
                case "/campaign-confirm":
                  return CreatorCampaignConfirm(
                    navKey: widget.navKey,
                    draftPosts: _draftPosts,
                    exit: _exitCreator,
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
    );
  }
}

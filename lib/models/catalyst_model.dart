import 'package:atlast_mobile_app/constants/catalyst_output_types.dart';
import 'package:atlast_mobile_app/constants/social_media_platforms.dart';

class CatalystBreakdown {
  String catalyst;

  String derivedPrompt;
  CatalystOutputTypes derivedOutputType;
  List<SocialMediaPlatforms> derivedPlatforms;

  // SINGLE POST PARAMS
  List<int> derivedPostTimestamps;

  // CAMPAIGN PARAMS
  CatalystCampaignOutputTypes? campaignOutputType;
  int? derivedStartTimestamp;
  int? derivedEndTimestamp;
  int? maximumPosts;

  CatalystBreakdown({
    required this.catalyst,
    required this.derivedPrompt,
    required this.derivedOutputType,
    this.derivedPostTimestamps = const [],
    this.derivedStartTimestamp,
    this.derivedEndTimestamp,
    this.derivedPlatforms = const [],
    this.campaignOutputType,
    this.maximumPosts,
  }) : super();
}

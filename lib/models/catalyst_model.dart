import 'package:atlast_mobile_app/constants/catalyst_output_types.dart';
import 'package:atlast_mobile_app/constants/social_media_platforms.dart';

class CatalystBreakdown {
  String catalyst;

  String derivedPrompt;
  CatalystOutputTypes derivedOutputType;
  int? derivedPostTimestamp;
  int? derivedStartTimestamp;
  int? derivedEndTimestamp;
  List<SocialMediaPlatforms> derivedPlatforms;

  CatalystBreakdown({
    required this.catalyst,
    required this.derivedPrompt,
    required this.derivedOutputType,
    this.derivedPostTimestamp,
    this.derivedStartTimestamp,
    this.derivedEndTimestamp,
    this.derivedPlatforms = const [],
  }) : super();
}

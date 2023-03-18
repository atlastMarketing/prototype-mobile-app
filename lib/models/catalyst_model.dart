import 'package:atlast_mobile_app/constants/catalyst_output_types.dart';
import 'package:atlast_mobile_app/constants/social_media_platforms.dart';

class CatalystBreakdown {
  String catalyst;

  String derivedPrompt;
  CatalystOutputTypes derivedOutputType;
  DateTime? derivedPostDate;
  DateTime? derivedStartDate;
  DateTime? derivedEndDate;
  List<SocialMediaPlatforms> derivedPlatforms;

  CatalystBreakdown({
    required this.catalyst,
    required this.derivedPrompt,
    required this.derivedOutputType,
    this.derivedPostDate,
    this.derivedStartDate,
    this.derivedEndDate,
    this.derivedPlatforms = const [],
  }) : super();
}

import 'package:atlast_mobile_app/constants/catalyst_output_types.dart';
import 'package:atlast_mobile_app/constants/social_media_platforms.dart';

class CatalystBreakdown {
  String catalyst;

  String derived_prompt;
  CatalystOutputTypes derived_output_type;
  DateTime? derived_post_date;
  DateTime? derived_start_date;
  DateTime? derived_end_date;
  List<SocialMediaPlatforms> derived_platforms;

  CatalystBreakdown({
    required this.catalyst,
    required this.derived_prompt,
    required this.derived_output_type,
    this.derived_post_date,
    this.derived_start_date,
    this.derived_end_date,
    this.derived_platforms = const [],
  }) : super();
}

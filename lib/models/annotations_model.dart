import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/constants/social_media_platforms.dart';
import 'package:atlast_mobile_app/utils/ner_regex.dart';

class DateAnnotation extends Annotation {
  int timestamp;

  DateAnnotation({
    required range,
    style,
    required this.timestamp,
  }) : super(
          range: range,
          style: style,
        );
}

class SocialMediaPlatformAnnotation extends Annotation {
  SocialMediaPlatforms platform;

  SocialMediaPlatformAnnotation({
    required range,
    style,
    required this.platform,
  }) : super(
          range: range,
          style: style,
        );
}

class CampaignOutputTypeAnnotation extends Annotation {
  NERRegexRangeCampaignOutputType campaignOutputType;

  CampaignOutputTypeAnnotation({
    required range,
    style,
    required this.campaignOutputType,
  }) : super(
          range: range,
          style: style,
        );
}

class Annotation extends Comparable<Annotation> {
  final TextRange range;
  final TextStyle? style;

  Annotation({
    required this.range,
    this.style,
  });

  @override
  int compareTo(Annotation other) {
    return range.start.compareTo(other.range.start);
  }

  @override
  String toString() {
    return 'Annotation(range:$range, style:$style)';
  }
}

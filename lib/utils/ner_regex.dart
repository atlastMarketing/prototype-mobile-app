// ((make|create)( \w )?)?( a )?((campaign)|(marketing campaign))

import 'package:google_mlkit_entity_extraction/google_mlkit_entity_extraction.dart';
import 'package:atlast_mobile_app/constants/social_media_platforms.dart';

class NERRegexRange {
  int start;
  int end;
  String matched;

  NERRegexRange({
    required this.start,
    required this.end,
    required this.matched,
  });
}

class NERRegexRangeDate extends NERRegexRange {
  final int timestamp;

  NERRegexRangeDate({
    required this.timestamp,
    required start,
    required end,
    required matched,
  }) : super(
          start: start,
          end: end,
          matched: matched,
        );
}

class NERRegexRangeSocialMediaPlatform extends NERRegexRange {
  final SocialMediaPlatforms platform;

  NERRegexRangeSocialMediaPlatform({
    required this.platform,
    required start,
    required end,
    required matched,
  }) : super(
          start: start,
          end: end,
          matched: matched,
        );
}

NERRegexRangeDate extractDateBuffersFromCatalyst(
  String catalyst,
  int start,
  int end,
  DateTimeEntity entity,
) {
  int fStart = start;
  int fEnd = end;
  String matched = catalyst.substring(start, end);

  RegExpMatch? match = RegExp(r"((in|on|at|and|from|to) )?(" + matched + r")",
          caseSensitive: false)
      .firstMatch(catalyst);

  if (match != null) {
    // get rid of leading whitespace
    if (match.start > 0 && catalyst[match.start - 1] == " ") {
      fStart = match.start - 1;
    } else {
      fStart = match.start;
    }
    fEnd = match.end;
    matched = catalyst.substring(fStart, fEnd);
  }
  return NERRegexRangeDate(
    timestamp: entity.timestamp * 1000,
    start: fStart,
    end: fEnd,
    matched: matched,
  );
}

List<NERRegexRangeSocialMediaPlatform> extractSocialMediaPlatformsFromCatalyst(
  String catalyst,
) {
  List<RegExpMatch> matches =
      RegExp(r"(facebook)|(instagram)", caseSensitive: false)
          .allMatches(catalyst)
          .toList();

  return matches.map((match) {
    String matched = catalyst.substring(match.start, match.end);

    SocialMediaPlatforms platform = SocialMediaPlatforms.instagram;
    if (matched.toLowerCase() == "facebook") {
      platform = SocialMediaPlatforms.facebook;
    }

    RegExpMatch? bufferMatch =
        RegExp(r"((in|on|at|and) )?(" + matched + r")", caseSensitive: false)
            .firstMatch(catalyst);

    int fStart = match.start;
    int fEnd = match.end;

    if (bufferMatch != null) {
      fStart = bufferMatch.start;
      fEnd = bufferMatch.end;
      matched = catalyst.substring(fStart, fEnd);
    }

    return NERRegexRangeSocialMediaPlatform(
      start: fStart,
      end: fEnd,
      matched: matched,
      platform: platform,
    );
  }).toList();
}

import 'package:flutter/foundation.dart';

import 'package:atlast_mobile_app/constants/catalyst_output_types.dart';
import 'package:atlast_mobile_app/constants/social_media_platforms.dart';
import 'package:atlast_mobile_app/constants/unique_char.dart';

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

class NERRegexRangeCampaignOutputType extends NERRegexRange {
  final CatalystCampaignOutputTypes campaignOutputType;

  NERRegexRangeCampaignOutputType({
    required this.campaignOutputType,
    required start,
    required end,
    required matched,
  }) : super(
          start: start,
          end: end,
          matched: matched,
        );
}

final List<String> startingDatePrefixes = [
  "from",
  "starting",
  "(starting from)",
  "(starting on)"
];
final String startingDatePrefixesRegexJoined = startingDatePrefixes.join("|");

bool isStartingDate(String input) {
  return RegExp(startingDatePrefixesRegexJoined).hasMatch(input);
}

final List<String> endingDatePrefixes = [
  "to",
  "until",
  "(lasting until)",
  "ending",
  "(ending on)"
];
final String endingDatePrefixesRegexJoined = endingDatePrefixes.join("|");

bool isEndingDate(String input) {
  return RegExp(endingDatePrefixesRegexJoined).hasMatch(input);
}

final String allDatePrefixesRegexJoined =
    [...startingDatePrefixes, ...endingDatePrefixes].join("|");

int castToMilliseconds(int sSinceEpoch) {
  return sSinceEpoch > 999999999999 ? sSinceEpoch : sSinceEpoch * 1000;
}

NERRegexRangeDate extractDateBuffersFromCatalyst(
  String catalyst,
  int start,
  int end,
  int timestamp,
) {
  int fStart = start;
  int fEnd = end;
  String matched = catalyst.substring(start, end);

  // use matcher and matchedHelper to avoid edge cases involving duplicate matches
  String matcher = UNIQUE_CHAR * matched.length;
  String matchedHelper =
      catalyst.replaceRange(start, end, UNIQUE_CHAR * matched.length);

  RegExpMatch? match = RegExp(
          r"((" + allDatePrefixesRegexJoined + r") )?(" + matcher + r")",
          caseSensitive: false)
      .firstMatch(matchedHelper);

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

  // check if milliseconds or microseconds
  return NERRegexRangeDate(
    timestamp: timestamp,
    start: fStart,
    end: fEnd,
    matched: matched,
  );
}

final String socialMediaRegex =
    SocialMediaPlatforms.values.map((e) => describeEnum(e)).join("|");

List<NERRegexRangeSocialMediaPlatform> extractSocialMediaPlatformsFromCatalyst(
  String catalyst,
) {
  List<RegExpMatch> matches =
      RegExp(r"(" + socialMediaRegex + r")", caseSensitive: false)
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

NERRegexRangeCampaignOutputType? extractCampaignOutputTypeFromCatalyst(
  String catalyst,
) {
  Iterable<RegExpMatch> matches =
      RegExp(r"(every month)|monthly", caseSensitive: false)
          .allMatches(catalyst);

  if (matches.isNotEmpty) {
    String matched = catalyst.substring(matches.first.start, matches.first.end);
    return NERRegexRangeCampaignOutputType(
      start: matches.first.start,
      end: matches.first.end,
      matched: matched,
      campaignOutputType: CatalystCampaignOutputTypes.monthly,
    );
  }

  matches =
      RegExp(r"(every week)|weekly", caseSensitive: false).allMatches(catalyst);

  if (matches.isNotEmpty) {
    String matched = catalyst.substring(matches.first.start, matches.first.end);
    return NERRegexRangeCampaignOutputType(
      start: matches.first.start,
      end: matches.first.end,
      matched: matched,
      campaignOutputType: CatalystCampaignOutputTypes.weekly,
    );
  }

  // special case of weekly where the day of the week is given
  matches = RegExp(
    r"(every monday)|(every tuesday)|(every wednesday)|(every thursday)|(every friday)",
    caseSensitive: false,
  ).allMatches(catalyst);

  if (matches.isNotEmpty) {
    String matched = catalyst.substring(matches.first.start, matches.first.end);
    int split = matched.indexOf(" ");
    int fEnd = matches.first.start + split;
    matched = catalyst.substring(matches.first.start, fEnd);
    // but only highlight "every"
    return NERRegexRangeCampaignOutputType(
      start: matches.first.start,
      end: fEnd,
      matched: matched,
      campaignOutputType: CatalystCampaignOutputTypes.weekly,
    );
  }

  matches = RegExp(r"(every day)|everyday|daily|every", caseSensitive: false)
      .allMatches(catalyst);

  if (matches.isNotEmpty) {
    String matched = catalyst.substring(matches.first.start, matches.first.end);
    return NERRegexRangeCampaignOutputType(
      start: matches.first.start,
      end: matches.first.end,
      matched: matched,
      campaignOutputType: CatalystCampaignOutputTypes.daily,
    );
  }

  return null;
}

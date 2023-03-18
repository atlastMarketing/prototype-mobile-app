// ((make|create)( \w )?)?( a )?((campaign)|(marketing campaign))

import 'package:google_mlkit_entity_extraction/google_mlkit_entity_extraction.dart';

class NERRegexExpanded {
  int start;
  int end;
  String matched;

  NERRegexExpanded({
    required this.start,
    required this.end,
    required this.matched,
  });
}

class NERRegexExpandedDate extends NERRegexExpanded {
  final int timestamp;

  NERRegexExpandedDate({
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

NERRegexExpandedDate extractDateBuffersFromCatalyst(
  String catalyst,
  int start,
  int end,
  DateTimeEntity entity,
) {
  int fStart = start;
  int fEnd = end;
  String matched = catalyst.substring(start, end);

  RegExpMatch? match =
      RegExp(r"((in|on|at) )?(" + matched + r")", caseSensitive: false)
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
  return NERRegexExpandedDate(
    timestamp: entity.timestamp * 1000,
    start: fStart,
    end: fEnd,
    matched: matched,
  );
}

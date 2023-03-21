import 'package:flutter/widgets.dart';

import 'package:atlast_mobile_app/constants/social_media_platforms.dart';

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

class AnnotatedTextController extends TextEditingController {
  // final List<Annotation> annotations;
  List<Annotation> annotations = [];

  // AnnotatedTextController({
  //   required this.annotations,
  // }) : super();

  List<Annotation> getRanges() {
    if (annotations.isEmpty) return [];
    var source = annotations;
    source.sort();

    List<Annotation> result = [];

    Annotation? prev;
    for (var item in source) {
      if (prev == null) {
        // First item, check if we need one before it.
        if (item.range.start > 0) {
          result.add(Annotation(
            range: TextRange(start: 0, end: item.range.start),
          ));
        }
        result.add(item);
        prev = item;
        continue;
      } else {
        // Consequent item, check if there is a gap between.
        if (prev.range.end > item.range.start) {
          // Invalid ranges
          throw StateError('Invalid (intersecting) ranges for annotated field');
        } else if (prev.range.end < item.range.start) {
          result.add(Annotation(
            range: TextRange(start: prev.range.end, end: item.range.start),
          ));
        }
        // Also add current annotation
        result.add(item);
        prev = item;
      }
    }
    // Also check for trailing range
    if (result.last.range.end < text.length) {
      result.add(Annotation(
        range: TextRange(start: result.last.range.end, end: text.length),
      ));
    }
    return result;
  }

  @override
  set text(String newText) {
    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
      composing: TextRange.empty,
    );
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    int textLength = text.length;
    if (annotations.isNotEmpty && textLength > 0) {
      var items = getRanges();
      var children = <TextSpan>[];
      for (var item in items) {
        if (item.range.end < textLength) {
          children.add(
            TextSpan(style: item.style, text: item.range.textInside(text)),
          );
        } else if (item.range.start <= textLength) {
          children.add(
            TextSpan(
                style: item.style,
                text: TextRange(start: item.range.start, end: text.length)
                    .textInside(text)),
          );
        }
      }
      return TextSpan(style: style, children: children);
    }

    return TextSpan(style: style, text: text);
  }
}

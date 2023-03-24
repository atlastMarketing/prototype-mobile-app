import 'package:atlast_mobile_app/constants/social_media_platforms.dart';

class PostDraft {
  SocialMediaPlatforms platform;
  int? dateTime;
  String? caption;
  String? imageUrl;

  PostDraft({
    required this.platform,
    this.dateTime,
    this.caption,
    this.imageUrl,
  });
}

class PostContent extends PostDraft {
  String id;

  PostContent({
    required this.id,
    required platform,
    required int dateTime,
    required String caption,
    imageUrl,
  }) : super(
          platform: platform,
          dateTime: dateTime,
          caption: caption,
          imageUrl: imageUrl,
        );

  @override
  String toString() {
    String date = dateTime.toString();
    if (dateTime != null) {
      try {
        date = DateTime.fromMillisecondsSinceEpoch(dateTime!).toIso8601String();
      } catch (_) {}
    }
    return """POST $id - {
      platform: $platform
      dateTime: $date
      caption: $caption
      imageUrl: $imageUrl
    }
    """;
  }
}

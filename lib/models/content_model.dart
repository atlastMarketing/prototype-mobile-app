import 'package:atlast_mobile_app/constants/social_media_platforms.dart';

class PostDraft {
  SocialMediaPlatforms platform;
  int? dateTime;
  String? caption;
  String? imageUrl;
  bool isDraft;

  PostDraft({
    required this.platform,
    this.dateTime,
    this.caption,
    this.imageUrl,
    this.isDraft = true,
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
    bool isDraft = true,
  }) : super(
          platform: platform,
          dateTime: dateTime,
          caption: caption,
          imageUrl: imageUrl,
          isDraft: isDraft,
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
      isDraft: $isDraft
    }
    """;
  }

  factory PostContent.fromJson(Map<String, dynamic> json) {
    return PostContent(
      id: json['_id'],
      platform: socialMediaPlatformsFromDB[json['platform']],
      dateTime: DateTime.parse(json['post_date']).millisecondsSinceEpoch,
      caption: json['caption'],
      imageUrl: json['image_url'],
      isDraft: json['is_draft'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'platform': convertToDBEnum(platform),
        'date_time': dateTime,
        'caption': caption,
        'image_url': imageUrl,
        'is_draft': isDraft
      };

  PostDraft toDraft() => PostDraft(
        platform: platform,
        dateTime: dateTime,
        caption: caption,
        imageUrl: imageUrl,
        isDraft: isDraft,
      );
}

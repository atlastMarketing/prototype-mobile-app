import 'package:atlast_mobile_app/constants/social_media_platforms.dart';

class ContentData {
  int? dateTime;
  String? caption;
  String? imageUrl;

  ContentData({
    this.dateTime,
    this.caption,
    this.imageUrl,
  });
}

class PostContent extends ContentData {
  int id;
  SocialMediaPlatforms platform;

  PostContent({
    required this.id,
    required dateTime,
    required caption,
    required this.platform,
    imageUrl,
  }) : super(
          dateTime: dateTime,
          caption: caption,
          imageUrl: imageUrl,
        );
}

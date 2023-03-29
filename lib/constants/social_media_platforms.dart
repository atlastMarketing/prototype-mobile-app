import 'package:flutter/foundation.dart';

enum SocialMediaPlatforms {
  instagram,
  facebook,
}

Map<SocialMediaPlatforms, String> socialMediaPlatformsOptions = {
  SocialMediaPlatforms.instagram: 'Instagram',
  SocialMediaPlatforms.facebook: 'Facebook',
};

Map<SocialMediaPlatforms, String> socialMediaPlatformsImageUrls = {
  SocialMediaPlatforms.instagram: 'assets/images/instagram.png',
  SocialMediaPlatforms.facebook: 'assets/images/facebook.png',
};

Map<String, SocialMediaPlatforms> socialMediaPlatformsFromDB = {
  convertToDBEnum(SocialMediaPlatforms.instagram):
      SocialMediaPlatforms.instagram,
  convertToDBEnum(SocialMediaPlatforms.facebook): SocialMediaPlatforms.facebook,
};

String convertToDBEnum(SocialMediaPlatforms platform) {
  return describeEnum(platform).toUpperCase();
}

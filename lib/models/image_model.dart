import 'dart:io';

class UploadedImage {
  final String imageUrl;
  final File image;

  UploadedImage({
    required this.imageUrl,
    required this.image,
  });
}

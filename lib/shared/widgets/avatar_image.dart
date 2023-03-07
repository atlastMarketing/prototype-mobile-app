import 'package:flutter/material.dart';

class AvatarImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;

  const AvatarImage(
    this.imageUrl, {
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.network(imageUrl, width: width, height: height),
    );
  }
}

import 'package:flutter/material.dart';

class AvatarImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final double borderRadius;

  const AvatarImage(
    this.imageUrl, {
    Key? key,
    this.width,
    this.height,
    this.borderRadius = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.network(
            Uri.encodeFull(imageUrl),
            fit: BoxFit.cover,
            errorBuilder: (_, obj, stack) => Image.network(
              Uri.encodeFull("https://i.imgur.com/oQIe4jC.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
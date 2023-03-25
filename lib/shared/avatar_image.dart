import 'package:flutter/material.dart';

class AvatarImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final double borderRadius;
  final BoxFit fit;

  const AvatarImage(
    this.imageUrl, {
    Key? key,
    this.width,
    this.height,
    this.borderRadius = 10.0,
    this.fit = BoxFit.cover,
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
            fit: fit,
            errorBuilder: (_, obj, stack) => Image.asset(
              "images/default_placeholder.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

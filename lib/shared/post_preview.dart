import 'package:flutter/material.dart';

class PostPreview extends StatelessWidget {
  final String imageUrl;
  final double size;
  final void Function() handlePressed;

  const PostPreview({
    Key? key,
    required this.imageUrl,
    required this.handlePressed,
    this.size = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          elevation: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              imageUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, obj, stack) => Image.asset(
                "images/default_placeholder.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(onTap: handlePressed),
          ),
        ),
      ],
    );
  }
}

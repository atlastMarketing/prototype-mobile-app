import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:flutter/material.dart';

class ImageUploader extends StatelessWidget {
  final void Function() handleTap;
  final double iconSize;
  final double? height;
  final double? width;
  final Color? iconColor;
  final Color? borderColor;

  const ImageUploader({
    Key? key,
    required this.handleTap,
    this.iconSize = 20,
    this.width,
    this.height,
    this.iconColor,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: handleTap,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor ?? AppColors.dark.withOpacity(0.3),
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.add,
            color: iconColor ?? AppColors.dark.withOpacity(0.5),
            size: iconSize,
          ),
        ),
      ),
    );
  }
}

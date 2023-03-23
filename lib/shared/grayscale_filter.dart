import 'package:flutter/material.dart';

class GrayscaleFilter extends StatelessWidget {
  final bool active;
  final Widget child;
  const GrayscaleFilter({
    Key? key,
    this.active = true,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(
        active
            ? [
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
              ]
            : [
                1,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
              ],
      ),
      child: child,
    );
  }
}

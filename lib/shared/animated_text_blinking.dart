import 'package:flutter/material.dart';

class AnimatedBlinkText extends StatefulWidget {
  final String text;
  final int duration;
  final TextStyle? textStyle;
  final double? width;

  const AnimatedBlinkText({
    Key? key,
    required this.text,
    this.duration = 800,
    this.textStyle,
    this.width,
  }) : super(key: key);
  @override
  _AnimatedBlinkTextState createState() => _AnimatedBlinkTextState();
}

class _AnimatedBlinkTextState extends State<AnimatedBlinkText>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.duration,
      ),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: SizedBox(
        width: widget.width,
        child: Text(
          widget.text,
          style: widget.textStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';

class CharacterAnimation extends StatefulWidget {
  final String text;

  const CharacterAnimation({
    super.key,
    required this.text, required Color color,
  });

  @override
  State<CharacterAnimation> createState() =>
      _CharacterAnimationState();
}

class _CharacterAnimationState
    extends State<CharacterAnimation>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fontSizeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _fontSizeAnimation = Tween<double>(
      begin: 14,
      end: 18,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fontSizeAnimation,
      builder: (context, child) {
        return Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              fontSize: _fontSizeAnimation.value,
              fontWeight: FontWeight.bold,
              //color: const Color(0xFFDC3F3F),
            ),
          ),
        );
      },
    );
  }
}
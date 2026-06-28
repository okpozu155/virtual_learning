import 'package:flutter/material.dart';

class CharacterAnimation extends StatefulWidget {
  final String text;
  final Color color;
  final bool animateDots;

  const CharacterAnimation({
    super.key,
    required this.text,
    required this.color,
    this.animateDots = false,
  });

  @override
  State<CharacterAnimation> createState() => _CharacterAnimationState();
}

class _CharacterAnimationState extends State<CharacterAnimation>
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
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _dotOpacity(int index) {
    final progress = (_controller.value + (index * 0.22)) % 1;
    final wave = progress < 0.5 ? progress * 2 : (1 - progress) * 2;
    return 0.35 + (Curves.easeInOut.transform(wave) * 0.65);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fontSizeAnimation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text.rich(
            TextSpan(
              text: widget.text,
              children: widget.animateDots
                  ? List.generate(
                      3,
                      (index) => TextSpan(
                        text: '.',
                        style: TextStyle(
                          color: widget.color.withValues(
                            alpha: _dotOpacity(index),
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: widget.animateDots ? 16 : _fontSizeAnimation.value,
              fontWeight: FontWeight.bold,
              color: widget.color,
            ),
          ),
        );
      },
    );
  }
}

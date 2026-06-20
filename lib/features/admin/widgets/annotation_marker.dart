import 'package:flutter/material.dart';

class AnnotationMarker extends StatelessWidget {
  final double x;
  final double y;

  const AnnotationMarker({
    super.key,
    required this.x,
    required this.y,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned(
                left: x * constraints.maxWidth,
                top: y * constraints.maxHeight,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
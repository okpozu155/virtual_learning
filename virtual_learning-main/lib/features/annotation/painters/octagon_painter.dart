import 'package:flutter/material.dart';
import 'dart:math';

class OctagonPainter extends CustomPainter {
  final Color color;
  final bool selected;

  const OctagonPainter({
    required this.color,
    this.selected = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.20)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = selected ? Colors.orange : color
      ..style = PaintingStyle.stroke
      ..strokeWidth = selected ? 3 : 2;

    final path = Path();

    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = min(
      size.width,
      size.height,
    ) /
        2;

    for (int i = 0; i < 8; i++) {
      final angle =
          (-90 + (360 / 8) * i) * pi / 180;

      final point = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant OctagonPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.selected != selected;
  }
}
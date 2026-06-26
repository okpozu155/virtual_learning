import 'package:flutter/material.dart';

class RectanglePainter extends CustomPainter {
  final Color color;
  final bool selected;

  const RectanglePainter({
    required this.color,
    this.selected = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = color.withOpacity(0.20)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = selected ? Colors.orange : color
      ..style = PaintingStyle.stroke
      ..strokeWidth = selected ? 3 : 2;

    final rect = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    );

    canvas.drawRect(rect, fillPaint);
    canvas.drawRect(rect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant RectanglePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.selected != selected;
  }
}
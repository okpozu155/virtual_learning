import 'package:flutter/material.dart';

class PolygonPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;

  PolygonPainter({
    required this.points,
    required this.color,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    if (points.length < 2) return;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.25)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();

    path.moveTo(
      points.first.dx,
      points.first.dy,
    );

    for (final point in points.skip(1)) {
      path.lineTo(
        point.dx,
        point.dy,
      );
    }

    path.close();

    canvas.drawPath(
      path,
      fillPaint,
    );

    canvas.drawPath(
      path,
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(
      covariant CustomPainter oldDelegate,
      ) {
    return true;
  }
}
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../data/models/hotspot_model.dart';

class SlideCanvas extends StatelessWidget {
  final String imagePath;

  final TransformationController transformationController;

  final List<HotspotModel> hotspots;

  final List<Map<String, dynamic>> annotations;

  final Function(HotspotModel) onHotspotTap;

  final Function(Map<String, dynamic>) onAnnotationTap;

  const SlideCanvas({
    super.key,
    required this.imagePath,
    required this.transformationController,
    required this.hotspots,
    required this.annotations,
    required this.onHotspotTap,
    required this.onAnnotationTap,
  });

  Color _hexToColor(dynamic value) {
    if (value == null) {
      return Colors.red;
    }

    // New annotation system stores color as an int.
    if (value is int) {
      return Color(value);
    }

    // Legacy annotation system stores color as a hex string.
    if (value is String) {
      try {
        var hex = value.replaceAll('#', '');

        if (hex.length == 6) {
          hex = 'FF$hex';
        }

        return Color(int.parse(hex, radix: 16));
      } catch (_) {
        return Colors.red;
      }
    }

    return Colors.red;
  }
  @override
  Widget build(BuildContext context) {
    const double hotspotSize = 30;
    const double annotationSize = 35;

    return InteractiveViewer(
      transformationController: transformationController,
      minScale: 1,
      maxScale: 10,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              /// Slide Image
              Positioned.fill(
                child: imagePath.startsWith('http')
                    ? Image.network(
                  imagePath,
                  fit: BoxFit.contain,
                )
                    : Image.file(
                  File(imagePath),
                  fit: BoxFit.contain,
                ),
              ),

              /// Polygon Annotations
              ...annotations
                  .where((a) => a['type'] == 'polygon' || a['shape'] != null)
                  .map(
                    (polygon) {
                  final points =
                  (polygon['points'] as List<dynamic>)
                      .map(
                        (p) => Offset(
                      (p['x'] as num).toDouble() *
                          constraints.maxWidth,
                      (p['y'] as num).toDouble() *
                          constraints.maxHeight,
                    ),
                  )
                      .toList();

                  return Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: PolygonPainter(
                          points: points,
                          color: _hexToColor(
                            polygon['color'],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              /// Hotspots
              ...hotspots.map(
                    (hotspot) => Positioned(
                  left: (hotspot.x * constraints.maxWidth) -
                      (hotspotSize / 2),
                  top: (hotspot.y * constraints.maxHeight) -
                      (hotspotSize / 2),
                  child: GestureDetector(
                    onTap: () => onHotspotTap(hotspot),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: hotspotSize,
                    ),
                  ),
                ),
              ),

              /// Point Annotations
              ...annotations
                  .where(
                    (annotation) =>
                annotation['type'] == null ||
                    annotation['type'] == 'point',
              )
                  .map(
                    (annotation) {
                  final double x =
                  ((annotation['x'] as num?)?.toDouble() ?? 0);

                  final double y =
                  ((annotation['y'] as num?)?.toDouble() ?? 0);

                  final String title =
                      annotation['title']?.toString() ?? '';

                  final Color markerColor =
                  _hexToColor(annotation['color']);

                  return Positioned(
                    left: (x * constraints.maxWidth) -
                        (annotationSize / 2),
                    top: (y * constraints.maxHeight) -
                        (annotationSize / 2),
                    child: GestureDetector(
                      onTap: () =>
                          onAnnotationTap(annotation),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: markerColor,
                            size: annotationSize,
                          ),

                          if (title.isNotEmpty)
                            Container(
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius:
                                BorderRadius.circular(4),
                              ),
                              child: Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight:
                                  FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Polygon Drawing Painter
class PolygonPainter extends CustomPainter {
  final List<Offset> points;

  final Color color;

  PolygonPainter({
    required this.points,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 3) return;

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
      covariant PolygonPainter oldDelegate,
      ) {
    return oldDelegate.points != points ||
        oldDelegate.color != color;
  }
}
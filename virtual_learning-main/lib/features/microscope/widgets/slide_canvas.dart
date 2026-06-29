import 'dart:io';

import 'package:flutter/material.dart';

import '../../../data/models/hotspot_model.dart';

class SlideCanvas extends StatefulWidget {
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

  @override
  State<SlideCanvas> createState() => _SlideCanvasState();
}

class _SlideCanvasState extends State<SlideCanvas> {
  ImageStream? _imageStream;

  ImageStreamListener? _imageStreamListener;

  Size? _imageSize;

  @override
  void initState() {
    super.initState();
    _resolveImageSize();
  }

  @override
  void didUpdateWidget(covariant SlideCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.imagePath != widget.imagePath) {
      _resolveImageSize();
    }
  }

  @override
  void dispose() {
    _removeImageListener();
    super.dispose();
  }

  ImageProvider _imageProvider() {
    return widget.imagePath.startsWith('http')
        ? NetworkImage(widget.imagePath)
        : FileImage(File(widget.imagePath));
  }

  void _removeImageListener() {
    final listener = _imageStreamListener;

    if (listener != null) {
      _imageStream?.removeListener(listener);
    }

    _imageStream = null;
    _imageStreamListener = null;
  }

  void _resolveImageSize() {
    _removeImageListener();

    final stream = _imageProvider().resolve(const ImageConfiguration());

    final listener = ImageStreamListener((info, _) {
      final image = info.image;
      final nextSize = Size(image.width.toDouble(), image.height.toDouble());

      if (!mounted || _imageSize == nextSize) {
        return;
      }

      setState(() {
        _imageSize = nextSize;
      });
    });

    _imageStream = stream;
    _imageStreamListener = listener;
    stream.addListener(listener);
  }

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

  Rect _slideRect(Size viewportSize) {
    final imageSize = _imageSize;

    if (imageSize == null ||
        imageSize.width <= 0 ||
        imageSize.height <= 0 ||
        viewportSize.width <= 0 ||
        viewportSize.height <= 0) {
      return Offset.zero & viewportSize;
    }

    final fitted = applyBoxFit(BoxFit.contain, imageSize, viewportSize);
    final destination = fitted.destination;
    final offset = Offset(
      (viewportSize.width - destination.width) / 2,
      (viewportSize.height - destination.height) / 2,
    );

    return offset & destination;
  }

  double _hotspotCoordinate(double value, double extent) {
    if (value <= 1) {
      return value * extent;
    }

    if (value <= 100) {
      return (value / 100) * extent;
    }

    return value;
  }

  double _annotationCoordinate({
    required dynamic value,
    required double slideExtent,
    required double viewportExtent,
    required bool pixelCoordinates,
  }) {
    final coordinate = (value as num?)?.toDouble() ?? 0;

    if (pixelCoordinates && coordinate <= slideExtent) {
      return coordinate;
    }

    if (pixelCoordinates && viewportExtent > 0) {
      return (coordinate / viewportExtent) * slideExtent;
    }

    if (coordinate <= 1) {
      return coordinate * slideExtent;
    }

    return (coordinate / 100) * slideExtent;
  }

  Offset _annotationPoint(
    dynamic point,
    Rect slideRect,
    Size viewportSize, {
    required bool pixelCoordinates,
  }) {
    if (point is! Map) {
      return Offset.zero;
    }

    return Offset(
      _annotationCoordinate(
        value: point['x'],
        slideExtent: slideRect.width,
        viewportExtent: viewportSize.width,
        pixelCoordinates: pixelCoordinates,
      ),
      _annotationCoordinate(
        value: point['y'],
        slideExtent: slideRect.height,
        viewportExtent: viewportSize.height,
        pixelCoordinates: pixelCoordinates,
      ),
    );
  }

  Offset _polygonCenter(List<Offset> points) {
    if (points.isEmpty) {
      return Offset.zero;
    }

    final sum = points.fold<Offset>(
      Offset.zero,
      (total, point) => total + point,
    );

    return Offset(sum.dx / points.length, sum.dy / points.length);
  }

  @override
  Widget build(BuildContext context) {
    const double hotspotSize = 30;
    const double annotationSize = 35;

    return InteractiveViewer(
      transformationController: widget.transformationController,
      minScale: 1,
      maxScale: 10,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final viewportSize = Size(
            constraints.maxWidth,
            constraints.maxHeight,
          );
          final slideRect = _slideRect(viewportSize);

          return Stack(
            children: [
              /// Slide Image
              Positioned.fill(
                child: Image(image: _imageProvider(), fit: BoxFit.contain),
              ),
              Positioned.fromRect(
                rect: slideRect,
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    /// Polygon Annotations
                    ...widget.annotations
                        .where(
                          (a) => a['type'] == 'polygon' || a['shape'] != null,
                        )
                        .map((polygon) {
                          final rawPoints = polygon['points'];
                          final pixelCoordinates = polygon['shape'] != null;

                          if (rawPoints is! List || rawPoints.length < 3) {
                            return const SizedBox.shrink();
                          }

                          final points = rawPoints
                              .map(
                                (point) => _annotationPoint(
                                  point,
                                  slideRect,
                                  viewportSize,
                                  pixelCoordinates: pixelCoordinates,
                                ),
                              )
                              .toList();

                          final center = _polygonCenter(points);
                          final title =
                              (polygon['title'] ?? polygon['label'])
                                  ?.toString() ??
                              '';
                          final markerColor = _hexToColor(polygon['color']);

                          return Stack(
                            children: [
                              Positioned.fill(
                                child: IgnorePointer(
                                  child: CustomPaint(
                                    painter: PolygonPainter(
                                      points: points,
                                      color: markerColor,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: center.dx - (annotationSize / 2),
                                top: center.dy - (annotationSize / 2),
                                child: GestureDetector(
                                  onTap: () => widget.onAnnotationTap(polygon),
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
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black87,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            title,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),

                    /// Hotspots
                    ...widget.hotspots.map(
                      (hotspot) => Positioned(
                        left:
                            _hotspotCoordinate(hotspot.x, slideRect.width) -
                            (hotspotSize / 2),
                        top:
                            _hotspotCoordinate(hotspot.y, slideRect.height) -
                            (hotspotSize / 2),
                        child: GestureDetector(
                          onTap: () => widget.onHotspotTap(hotspot),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: hotspotSize,
                          ),
                        ),
                      ),
                    ),

                    /// Point Annotations
                    ...widget.annotations
                        .where(
                          (annotation) =>
                              annotation['type'] == null ||
                              annotation['type'] == 'point',
                        )
                        .map((annotation) {
                          final double x = _annotationCoordinate(
                            value: annotation['x'],
                            slideExtent: slideRect.width,
                            viewportExtent: viewportSize.width,
                            pixelCoordinates: false,
                          );

                          final double y = _annotationCoordinate(
                            value: annotation['y'],
                            slideExtent: slideRect.height,
                            viewportExtent: viewportSize.height,
                            pixelCoordinates: false,
                          );

                          final String title =
                              annotation['title']?.toString() ?? '';

                          final Color markerColor = _hexToColor(
                            annotation['color'],
                          );

                          return Positioned(
                            left: x - (annotationSize / 2),
                            top: y - (annotationSize / 2),
                            child: GestureDetector(
                              onTap: () => widget.onAnnotationTap(annotation),
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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black87,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ],
                ),
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

  PolygonPainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 3) return;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();

    path.moveTo(points.first.dx, points.first.dy);

    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }

    path.close();

    canvas.drawPath(path, fillPaint);

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant PolygonPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}

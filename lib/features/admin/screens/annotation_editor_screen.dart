import 'package:flutter/material.dart';

import '../widgets/annotation_dialog.dart';
import '../widgets/polygon_painter.dart';
import '../../../data/repositories/annotation_repository.dart';

class AnnotationEditorScreen extends StatefulWidget {
  final String slideId;
  final String imageUrl;

  const AnnotationEditorScreen({
    super.key,
    required this.slideId,
    required this.imageUrl,
  });

  @override
  State<AnnotationEditorScreen> createState() =>
      _AnnotationEditorScreenState();
}

class _AnnotationEditorScreenState
    extends State<AnnotationEditorScreen> {
  final AnnotationRepository repository =
  AnnotationRepository();

  List<Map<String, dynamic>> annotations = [];

  List<Offset> polygonPoints = [];

  bool polygonMode = false;

  @override
  void initState() {
    super.initState();
    loadAnnotations();
  }

  Future<void> loadAnnotations() async {
    final data =
    await repository.getAnnotations(widget.slideId);

    if (!mounted) return;

    setState(() {
      annotations = data;
    });
  }

  Color _hexToColor(String? hex) {
    if (hex == null || hex.isEmpty) {
      return Colors.blue;
    }

    final cleaned =
    hex.replaceAll('#', '');

    return Color(
      int.parse(
        'FF$cleaned',
        radix: 16,
      ),
    );
  }

  void createMarker(
      TapDownDetails details,
      ) {
    final RenderBox box =
    context.findRenderObject() as RenderBox;

    final width = box.size.width;
    final height = box.size.height;

    final x =
        details.localPosition.dx / width;

    final y =
        details.localPosition.dy / height;

    /// Polygon mode
    if (polygonMode) {
      setState(() {
        polygonPoints.add(
          Offset(x, y),
        );
      });

      return;
    }

    /// Point annotation
    showDialog(
      context: context,
      builder: (_) => AnnotationDialog(
        onSave: (
            title,
            description,
            notes,
            color,
            ) async {
          await repository.saveAnnotation(
            slideId: widget.slideId,
            title: title,
            description: description,
            notes: notes,
            x: x,
            y: y,
            color: color,
          );

          await loadAnnotations();
        },
      ),
    );
  }

  Future<void> _savePolygon() async {
    showDialog(
      context: context,
      builder: (_) => AnnotationDialog(
        onSave: (
            title,
            description,
            notes,
            color,
            ) async {
          await repository.savePolygonAnnotation(
            slideId: widget.slideId,
            title: title,
            description: description,
            notes: notes,
            color: color,
            points: polygonPoints
                .map(
                  (point) => {
                'x': point.dx,
                'y': point.dy,
              },
            )
                .toList(),
          );

          polygonPoints.clear();

          await loadAnnotations();

          if (!mounted) return;

          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pointAnnotations =
    annotations.where(
          (a) =>
      a['type'] == null ||
          a['type'] == 'point',
    );

    final polygonAnnotations =
    annotations.where(
          (a) => a['type'] == 'polygon',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Annotation Editor',
        ),
        actions: [
          IconButton(
            icon: Icon(
              polygonMode
                  ? Icons.crop_square
                  : Icons.location_on,
            ),
            onPressed: () {
              setState(() {
                polygonMode = !polygonMode;
                polygonPoints.clear();
              });
            },
          ),
        ],
      ),

      floatingActionButton:
      polygonMode &&
          polygonPoints.length >= 3
          ? FloatingActionButton.extended(
        onPressed: _savePolygon,
        icon: const Icon(
          Icons.save,
        ),
        label: const Text(
          'Save Polygon',
        ),
      )
          : null,

      body: LayoutBuilder(
        builder: (
            context,
            constraints,
            ) {
          return GestureDetector(
            onTapDown: createMarker,
            child: Stack(
              children: [
                /// Slide image
                Positioned.fill(
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),

                /// Saved polygons
                ...polygonAnnotations.map(
                      (polygon) {
                    final points =
                    (polygon['points'] as List)
                        .map(
                          (point) => Offset(
                        (point['x'] as num)
                            .toDouble() *
                            constraints.maxWidth,
                        (point['y'] as num)
                            .toDouble() *
                            constraints.maxHeight,
                      ),
                    )
                        .toList();

                    return CustomPaint(
                      size: Size(
                        constraints.maxWidth,
                        constraints.maxHeight,
                      ),
                      painter: PolygonPainter(
                        points: points,
                        color: _hexToColor(
                          polygon['color'],
                        ),
                      ),
                    );
                  },
                ),

                /// Polygon currently being drawn
                if (polygonPoints.length >= 2)
                  CustomPaint(
                    size: Size(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    ),
                    painter: PolygonPainter(
                      points: polygonPoints
                          .map(
                            (point) => Offset(
                          point.dx *
                              constraints.maxWidth,
                          point.dy *
                              constraints.maxHeight,
                        ),
                      )
                          .toList(),
                      color: Colors.green,
                    ),
                  ),

                /// Point annotations
                ...pointAnnotations.map(
                      (annotation) {
                    final x =
                    ((annotation['x'] as num?)
                        ?.toDouble() ??
                        0);

                    final y =
                    ((annotation['y'] as num?)
                        ?.toDouble() ??
                        0);

                    return Positioned(
                      left:
                      (x * constraints.maxWidth) -
                          18,
                      top:
                      (y * constraints.maxHeight) -
                          18,
                      child: Tooltip(
                        message:
                        annotation['title'] ??
                            '',
                        child: Icon(
                          Icons.location_on,
                          color: _hexToColor(
                            annotation['color'],
                          ),
                          size: 36,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
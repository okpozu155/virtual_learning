import 'package:flutter/material.dart';

import '../controllers/annotation_controller.dart';
import '../widgets/annotation_dialog.dart';
import '../widgets/annotation_marker.dart';

class AnnotationEditorScreen
    extends StatefulWidget {
  final String slideId;
  final String imageUrl;

  const AnnotationEditorScreen({
    super.key,
    required this.slideId,
    required this.imageUrl,
  });

  @override
  State<AnnotationEditorScreen>
  createState() =>
      _AnnotationEditorScreenState();
}


class _AnnotationEditorScreenState
    extends State<AnnotationEditorScreen> {
  final controller =
  AnnotationController();

  final List<Widget> markers = [];

  @override
  void initState() {
    super.initState();

    debugPrint(
      "Annotation screen opened",
    );

    debugPrint(
      "slideId = ${widget.slideId}",
    );

    debugPrint(
      "imageUrl = ${widget.imageUrl}",
    );
  }

  void createMarker(
      TapDownDetails details) {
    final RenderBox box =
    context.findRenderObject() as RenderBox;

    final width = box.size.width;
    final height = box.size.height;

    final x =
        details.localPosition.dx / width;

    final y =
        details.localPosition.dy / height;

    showDialog(
      context: context,
      builder: (_) =>
          AnnotationDialog(
            onSave: (
                title,
                description,
                notes,
                ) async {
              await controller.createHotspot(
                slideId: widget.slideId,
                title: title,
                description: description,
                notes: notes,
                x: x,
                y: y,
              );

              setState(() {
                markers.add(
                  AnnotationMarker(
                    x: x,
                    y: y,
                  ),
                );
              });
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(title: const Text(
        "Annotation Editor",
      )),
      body: GestureDetector(
        onTapDown: createMarker,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            ...markers,
          ],
        ),
      ),
    );
  }
}
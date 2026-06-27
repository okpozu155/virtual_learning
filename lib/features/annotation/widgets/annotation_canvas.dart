import 'package:flutter/material.dart';

import '../controllers/annotation_editor_controller.dart';
import '../models/annotation_shape.dart';
import 'annotation_shape_widget.dart';

class AnnotationCanvas extends StatelessWidget {
  final AnnotationEditorController controller;
  final String slideId;
  final String imageUrl;
  final Future<void> Function()? onShapePlaced;
  final Future<void> Function(AnnotationShape shape)? onShapeEdit;

  const AnnotationCanvas({
    super.key,
    required this.controller,
    required this.slideId,
    required this.imageUrl,
    this.onShapePlaced,
    this.onShapeEdit,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, _) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,

          onTapUp: (details) async {
            if (controller.placingShape) {
              final shape = await controller.placeShape(
                slideId: slideId,
                position: details.localPosition,
              );

              if (shape != null) {
                await onShapePlaced?.call();
              }
            } else {
              controller.clearSelection();
            }
          },

          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 8,
            boundaryMargin: const EdgeInsets.all(500),

            child: Stack(
              children: [
                //-------------------------------------------------
                // Slide Image
                //-------------------------------------------------

                Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),

                //-------------------------------------------------
                // Annotation Shapes
                //-------------------------------------------------

                ...controller.shapes.map(
                      (AnnotationShape shape) {
                    return AnnotationShapeWidget(
                      shape: shape,
                      selected: shape.selected,

                      onTap: () {
                        controller.selectShape(shape);
                      },

                      onDoubleTap: () async {
                        controller.selectShape(shape);
                        await onShapeEdit?.call(shape);
                      },

                      onMove: (delta) async {
                        await controller.moveSelected(
                          slideId: slideId,
                          delta: delta,
                        );
                      },

                      onResize: (
                          width,
                          height,
                          ) async {
                        await controller.resizeSelected(
                          slideId: slideId,
                          width: width,
                          height: height,
                        );
                      },
                    );
                  },
                ),

                //-------------------------------------------------
                // Placement Hint
                //-------------------------------------------------

                if (controller.placingShape)
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Card(
                      color: Colors.black87,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          "Tap anywhere to place the ${controller.placingType!.name}.",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

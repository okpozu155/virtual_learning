import 'package:flutter/material.dart';

import '../models/annotation_shape.dart';
import '../painters/rectangle_painter.dart';
import '../painters/octagon_painter.dart';
import 'resize_handle.dart';

class AnnotationShapeWidget extends StatelessWidget {
  final AnnotationShape shape;

  final bool selected;

  final VoidCallback? onTap;

  final ValueChanged<Offset> onMove;

  final void Function(double width, double height) onResize;

  const AnnotationShapeWidget({
    super.key,
    required this.shape,
    required this.selected,
    required this.onTap,
    required this.onMove,
    required this.onResize,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: shape.rect.left,
      top: shape.rect.top,
      child: GestureDetector(
        onTap: onTap,

        // Drag entire shape
        onPanUpdate: (details) {
          onMove(details.delta);
        },

        child: Transform.rotate(
          angle: shape.rotation,
          child: SizedBox(
            width: shape.width,
            height: shape.height,
            child: Stack(
              clipBehavior: Clip.none,
              children: [

                //-----------------------------------------
                // Shape
                //-----------------------------------------

                Positioned.fill(
                  child: CustomPaint(
                    painter: shape.type ==
                        AnnotationShapeType.rectangle
                        ? RectanglePainter(
                      color: shape.color,
                      selected: selected,
                    )
                        : OctagonPainter(
                      color: shape.color,
                      selected: selected,
                    ),
                  ),
                ),

                //-----------------------------------------
                // Resize Handles
                //-----------------------------------------

                if (selected) ...[
                  _handle(
                    Alignment.topLeft,
                        (delta) {
                      onMove(delta);

                      onResize(
                        shape.width - delta.dx,
                        shape.height - delta.dy,
                      );
                    },
                  ),

                  _handle(
                    Alignment.topRight,
                        (delta) {
                      onMove(
                        Offset(0, delta.dy),
                      );

                      onResize(
                        shape.width + delta.dx,
                        shape.height - delta.dy,
                      );
                    },
                  ),

                  _handle(
                    Alignment.bottomLeft,
                        (delta) {
                      onMove(
                        Offset(delta.dx, 0),
                      );

                      onResize(
                        shape.width - delta.dx,
                        shape.height + delta.dy,
                      );
                    },
                  ),

                  _handle(
                    Alignment.bottomRight,
                        (delta) {
                      onResize(
                        shape.width + delta.dx,
                        shape.height + delta.dy,
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _handle(
      Alignment alignment,
      ValueChanged<Offset> drag,
      ) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanUpdate: (details) {
          drag(details.delta);
        },
        child: const SizedBox(
          width: 28,
          height: 28,
          child: const ResizeHandle(
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
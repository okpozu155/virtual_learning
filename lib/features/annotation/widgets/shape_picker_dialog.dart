import 'package:flutter/material.dart';

import '../models/annotation_shape.dart';

class ShapePickerDialog extends StatelessWidget {
  const ShapePickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Choose Shape"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.rectangle_outlined),
            title: const Text("Rectangle"),
            onTap: () {
              Navigator.pop(
                context,
                AnnotationShapeType.rectangle,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.stop_circle_outlined),
            title: const Text("Octagon"),
            onTap: () {
              Navigator.pop(
                context,
                AnnotationShapeType.octagon,
              );
            },
          ),
        ],
      ),
    );
  }
}
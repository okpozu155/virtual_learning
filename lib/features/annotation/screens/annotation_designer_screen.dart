import 'package:flutter/material.dart';

import '../controllers/annotation_editor_controller.dart';
import '../models/annotation_shape.dart';
import '../widgets/annotation_canvas.dart';
import '../widgets/shape_picker_dialog.dart';

class AnnotationDesignerScreen extends StatefulWidget {
  final String slideId;
  final String imageUrl;

  const AnnotationDesignerScreen({
    super.key,
    required this.slideId,
    required this.imageUrl,
  });

  @override
  State<AnnotationDesignerScreen> createState() =>
      _AnnotationDesignerScreenState();
}

class _AnnotationDesignerScreenState
    extends State<AnnotationDesignerScreen> {
  final AnnotationEditorController controller =
  AnnotationEditorController();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await controller.loadShapes(widget.slideId);

    controller.startRealtimeSync(widget.slideId);

    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }

  Future<void> _addShape() async {
    final AnnotationShapeType? type =
    await showDialog<AnnotationShapeType>(
      context: context,
      builder: (_) => const ShapePickerDialog(),
    );

    if (type == null) return;

    controller.beginPlacement(type);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Tap anywhere on the slide to place a ${type.name}.",
        ),
      ),
    );
  }

  Future<void> _duplicateShape() async {
    await controller.duplicateSelected(
      widget.slideId,
    );
  }

  Future<void> _deleteShape() async {
    if (!controller.hasSelection) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Select a shape first.",
          ),
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Shape"),
        content: const Text(
          "Delete the selected annotation?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await controller.deleteSelected(
        widget.slideId,
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Annotation Designer"),
        actions: [
          IconButton(
            tooltip: "Add Shape",
            icon: const Icon(Icons.add_box_outlined),
            onPressed: _addShape,
          ),
          IconButton(
            tooltip: "Duplicate",
            icon: const Icon(Icons.copy),
            onPressed: controller.hasSelection
                ? _duplicateShape
                : null,
          ),
          IconButton(
            tooltip: "Delete",
            icon: const Icon(Icons.delete),
            onPressed: controller.hasSelection
                ? _deleteShape
                : null,
          ),
        ],
      ),
      body: loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : AnnotationCanvas(
        controller: controller,
        slideId: widget.slideId,
        imageUrl: widget.imageUrl,
      ),
    );
  }
}
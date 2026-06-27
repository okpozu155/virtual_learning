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

  Future<void> _editSelectedShape() async {
    final shape = controller.selectedShape;

    if (shape == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Select a shape first.",
          ),
        ),
      );
      return;
    }

    final titleController = TextEditingController(
      text: shape.title,
    );
    final descriptionController = TextEditingController(
      text: shape.description,
    );
    final notesController = TextEditingController(
      text: shape.notes,
    );

    final colors = <Color>[
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.black,
    ];

    Color selectedColor = shape.color;

    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Annotation Details"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: "Title",
                    ),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: "Description",
                    ),
                    minLines: 2,
                    maxLines: 4,
                  ),
                  TextField(
                    controller: notesController,
                    decoration: const InputDecoration(
                      labelText: "Notes",
                    ),
                    minLines: 2,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    children: colors.map((color) {
                      final isSelected =
                          color.toARGB32() == selectedColor.toARGB32();

                      return InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          setDialogState(() {
                            selectedColor = color;
                          });
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Save"),
              ),
            ],
          );
        },
      ),
    );

    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    final notes = notesController.text.trim();

    titleController.dispose();
    descriptionController.dispose();
    notesController.dispose();

    if (saved != true) return;

    await controller.updateShapeDetails(
      slideId: widget.slideId,
      title: title,
      description: description,
      notes: notes,
      color: selectedColor,
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
          AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                    tooltip: "Edit Details",
                    icon: const Icon(Icons.edit_note),
                    onPressed: controller.hasSelection
                        ? _editSelectedShape
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
              );
            },
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
        onShapePlaced: _editSelectedShape,
        onShapeEdit: (_) => _editSelectedShape(),
      ),
    );
  }
}

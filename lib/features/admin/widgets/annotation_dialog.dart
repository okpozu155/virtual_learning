import 'package:flutter/material.dart';

class AnnotationDialog extends StatefulWidget {
  final Function(
      String title,
      String description,
      String notes,
      String color,
      ) onSave;

  final String? initialTitle;
  final String? initialDescription;
  final String? initialNotes;
  final String? initialColor;

  const AnnotationDialog({
    super.key,
    required this.onSave,
    this.initialTitle,
    this.initialDescription,
    this.initialNotes,
    this.initialColor,
  });

  @override
  State<AnnotationDialog> createState() =>
      _AnnotationDialogState();
}

class _AnnotationDialogState
    extends State<AnnotationDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController notesController;

  String selectedColor = "#FF0000";

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.initialTitle ?? '',
    );

    descriptionController = TextEditingController(
      text: widget.initialDescription ?? '',
    );

    notesController = TextEditingController(
      text: widget.initialNotes ?? '',
    );

    selectedColor =
        widget.initialColor ?? "#FF0000";
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.initialTitle == null
            ? "Create Annotation"
            : "Edit Annotation",
      ),
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

            const SizedBox(height: 12),

            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Notes",
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedColor,
              decoration: const InputDecoration(
                labelText: "Annotation Color",
              ),
              items: const [
                "#FF0000",
                "#00FF00",
                "#0000FF",
                "#FFFF00",
                "#FF00FF",
                "#00FFFF",
              ]
                  .map(
                    (color) => DropdownMenuItem(
                  value: color,
                  child: Text(color),
                ),
              )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedColor = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(
              titleController.text.trim(),
              descriptionController.text.trim(),
              notesController.text.trim(),
              selectedColor,
            );

            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
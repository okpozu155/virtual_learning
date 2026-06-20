import 'package:flutter/material.dart';

class AnnotationDialog extends StatefulWidget {
  final Function(
      String title,
      String description,
      String notes,
      ) onSave;

  const AnnotationDialog({
    super.key,
    required this.onSave,
  });

  @override
  State<AnnotationDialog> createState() =>
      _AnnotationDialogState();
}

class _AnnotationDialogState
    extends State<AnnotationDialog> {
  final titleController =
  TextEditingController();

  final descriptionController =
  TextEditingController();

  final notesController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Create Hotspot"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration:
              const InputDecoration(
                labelText: "Title",
              ),
            ),
            TextField(
              controller:
              descriptionController,
              decoration:
              const InputDecoration(
                labelText: "Description",
              ),
            ),
            TextField(
              controller: notesController,
              decoration:
              const InputDecoration(
                labelText: "Notes",
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(
              titleController.text,
              descriptionController.text,
              notesController.text,
            );

            Navigator.pop(context);
          },
          child: const Text("Save"),
        )
      ],
    );
  }
}
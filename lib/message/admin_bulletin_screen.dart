import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminBulletinScreen extends StatefulWidget {
  const AdminBulletinScreen({super.key});

  @override
  State<AdminBulletinScreen> createState() =>
      _AdminBulletinScreenState();
}

class _AdminBulletinScreenState
    extends State<AdminBulletinScreen> {
  final titleController =
  TextEditingController();

  final messageController =
  TextEditingController();

  bool loading = false;

  Future<void> publish() async {
    if (titleController.text.trim().isEmpty ||
        messageController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      loading = true;
    });

    await FirebaseFirestore.instance
        .collection('announcements')
        .add({
      'title': titleController.text.trim(),
      'message': messageController.text.trim(),
      'createdAt':
      FieldValue.serverTimestamp(),
      'createdBy': 'admin',
      'priority': 'normal',
    });

    titleController.clear();
    messageController.clear();

    setState(() {
      loading = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Announcement Published",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(title: const Text("Bulletin")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration:
              const InputDecoration(
                labelText: "Title",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: messageController,
              maxLines: 6,
              decoration:
              const InputDecoration(
                labelText: "Announcement",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed:
              loading ? null : publish,
              child: const Text(
                "Publish",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
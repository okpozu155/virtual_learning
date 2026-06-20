import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageAdminScreen extends StatefulWidget {
  const MessageAdminScreen({super.key});

  @override
  State<MessageAdminScreen> createState() =>
      _MessageAdminScreenState();
}

class _MessageAdminScreenState
    extends State<MessageAdminScreen> {
  final TextEditingController messageController =
  TextEditingController();

  bool sending = false;

  Future<void> sendMessage() async {
    final text = messageController.text.trim();

    if (text.isEmpty) return;

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    setState(() {
      sending = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('messages')
          .add({
        'senderId': user.uid,
        'senderName':
        user.displayName ?? 'Student',
        'senderEmail': user.email ?? '',
        'message': text,
        'timestamp':
        FieldValue.serverTimestamp(),
        'read': false,
        'reply': '',
      });

      messageController.clear();

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Message sent successfully',
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      sending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Message Admin",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: messageController,
              maxLines: 8,
              decoration:
              const InputDecoration(
                hintText:
                "Type your message here...",
                border:
                OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                sending ? null : sendMessage,
                child: sending
                    ? const CircularProgressIndicator()
                    : const Text(
                  "Send Message",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
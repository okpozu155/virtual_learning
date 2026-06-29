import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentChatScreen extends StatefulWidget {
  final String conversationId;

  const StudentChatScreen({
    super.key,
    required this.conversationId,
  });

  @override
  State<StudentChatScreen> createState() =>
      _StudentChatScreenState();
}

class _StudentChatScreenState
    extends State<StudentChatScreen> {
  final TextEditingController controller =
  TextEditingController();

  Future<void> sendMessage() async {
    if (controller.text.trim().isEmpty) {
      return;
    }

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final text = controller.text.trim();

    await FirebaseFirestore.instance
        .collection('messages')
        .doc(widget.conversationId)
        .collection('chats')
        .add({
      'senderId': user.uid,
      'senderName':
      user.displayName ?? "Student",
      'text': text,
      'timestamp':
      FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance
        .collection('messages')
        .doc(widget.conversationId)
        .update({
      'lastMessage': text,
      'updatedAt':
      FieldValue.serverTimestamp(),
    });

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat with Admin"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(widget.conversationId)
                  .collection('chats')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child:
                    CircularProgressIndicator(),
                  );
                }

                final messages =
                    snapshot.data!.docs;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data =
                    messages[index].data()
                    as Map<String, dynamic>;

                    final isMe =
                        data['senderId'] ==
                            user?.uid;

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin:
                        const EdgeInsets.all(8),
                        padding:
                        const EdgeInsets.all(
                            12),
                        decoration:
                        BoxDecoration(
                          color: isMe
                              ? Colors.blue
                              : Colors.grey
                              .shade300,
                          borderRadius:
                          BorderRadius
                              .circular(12),
                        ),
                        child: Text(
                          data['text'] ?? '',
                          style: TextStyle(
                            color: isMe
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          SafeArea(
            child: Padding(
              padding:
              const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration:
                      const InputDecoration(
                        hintText:
                        "Type a message...",
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: sendMessage,
                    icon:
                    const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'student_chat_screen.dart';

class StudentInboxScreen extends StatelessWidget {
  const StudentInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser =
        FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Please login first",
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Messages",
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .where(
          'participants',
          arrayContains: currentUser.uid,
        )
            .orderBy(
          'updatedAt',
          descending: true,
        )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());

            return const Center(
              child: Text(
                "Unable to load messages",
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No messages yet",
              ),
            );
          }

          final conversations =
              snapshot.data!.docs;

          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final doc =
              conversations[index];

              final data =
              doc.data()
              as Map<String, dynamic>;

              return Card(
                margin:
                const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(
                      Icons.admin_panel_settings,
                    ),
                  ),
                  title: Text(
                    data['adminName'] ??
                        'Admin',
                  ),
                  subtitle: Text(
                    data['lastMessage'] ??
                        'No messages',
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            StudentChatScreen(
                              conversationId:
                              doc.id,
                            ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
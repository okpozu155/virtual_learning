import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentInboxScreen extends StatelessWidget {
  const StudentInboxScreen({super.key});

  void showMessageDetails(
      BuildContext context,
      Map<String, dynamic> data,
      ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Message Details"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Your Message",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(data['message'] ?? ''),

              const SizedBox(height: 20),

              const Text(
                "Admin Reply",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                (data['reply'] ?? '').toString().isNotEmpty
                    ? data['reply']
                    : "No reply yet",
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

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
          'senderId',
          isEqualTo: currentUser.uid,
        )
            .orderBy(
          'timestamp',
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

          final messages = snapshot.data!.docs;

          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final doc = messages[index];

              final data =
              doc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                    data['replied'] == true
                        ? Colors.green
                        : Colors.orange,
                    child: Icon(
                      data['replied'] == true
                          ? Icons.mark_email_read
                          : Icons.mark_email_unread,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    data['message'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Padding(
                    padding:
                    const EdgeInsets.only(top: 8),
                    child: Text(
                      (data['reply'] ?? '')
                          .toString()
                          .isNotEmpty
                          ? "Admin: ${data['reply']}"
                          : "Awaiting admin reply...",
                      style: TextStyle(
                        color: (data['reply'] ?? '')
                            .toString()
                            .isNotEmpty
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                  ),
                  trailing: data['replied'] == true
                      ? const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )
                      : const Icon(
                    Icons.access_time,
                    color: Colors.orange,
                  ),
                  onTap: () {
                    showMessageDetails(
                      context,
                      data,
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
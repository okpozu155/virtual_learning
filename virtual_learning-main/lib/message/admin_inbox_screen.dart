import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminInboxScreen extends StatelessWidget {
  const AdminInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Messages"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('messages')
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

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No messages found",
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];

              final data =
              doc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      data['read'] == true
                          ? Icons.mark_email_read
                          : Icons.mark_email_unread,
                    ),
                  ),
                  title: Text(
                    data['senderName'] ??
                        'Unknown Student',
                  ),
                  subtitle: Text(
                    data['message'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: data['replied'] == true
                      ? const Icon(
                    Icons.reply,
                    color: Colors.green,
                  )
                      : const Icon(
                    Icons.pending_actions,
                    color: Colors.orange,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            MessageDetailsScreen(
                              messageId: doc.id,
                              data: data,
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

class MessageDetailsScreen extends StatefulWidget {
  final String messageId;
  final Map<String, dynamic> data;

  const MessageDetailsScreen({
    super.key,
    required this.messageId,
    required this.data,
  });

  @override
  State<MessageDetailsScreen> createState() =>
      _MessageDetailsScreenState();
}

class _MessageDetailsScreenState
    extends State<MessageDetailsScreen> {
  late TextEditingController replyController;

  bool saving = false;

  @override
  void initState() {
    super.initState();

    replyController = TextEditingController(
      text: widget.data['reply'] ?? '',
    );

    markAsRead();
  }

  Future<void> markAsRead() async {
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(widget.messageId)
        .update({
      'read': true,
    });
  }

  Future<void> saveReply() async {
    final reply =
    replyController.text.trim();

    if (reply.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Reply cannot be empty",
          ),
        ),
      );
      return;
    }

    setState(() {
      saving = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(widget.messageId)
          .update({
        'reply': reply,
        'replied': true,
        'replyTimestamp':
        FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Reply saved",
          ),
        ),
      );
    } catch (e) {
      debugPrint(
        "Reply error: $e",
      );
    }

    if (mounted) {
      setState(() {
        saving = false;
      });
    }
  }

  Future<void> deleteMessage() async {
    final confirm =
    await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Delete Message",
        ),
        content: const Text(
          "Are you sure you want to delete this message?",
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(
                  context,
                  false,
                ),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(
                  context,
                  true,
                ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await FirebaseFirestore.instance
        .collection('messages')
        .doc(widget.messageId)
        .delete();

    if (!mounted) return;

    Navigator.pop(context);
  }

  String formatTimestamp(dynamic timestamp) {
    if (timestamp == null) {
      return "Unknown";
    }

    if (timestamp is Timestamp) {
      return timestamp
          .toDate()
          .toString();
    }

    return timestamp.toString();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Message Details",
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: deleteMessage,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding:
        const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding:
                const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['senderName'] ??
                          '',
                      style:
                      const TextStyle(
                        fontSize: 20,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      data['senderEmail'] ??
                          '',
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Sent: ${formatTimestamp(data['timestamp'])}",
                    ),

                    const Divider(),

                    const Text(
                      "Student Message",
                      style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      data['message'] ?? '',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Reply",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller:
              replyController,
              maxLines: 6,
              decoration:
              const InputDecoration(
                border:
                OutlineInputBorder(),
                hintText:
                "Type your reply...",
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.send,
                ),
                label: Text(
                  saving
                      ? "Saving..."
                      : "Send Reply",
                ),
                onPressed:
                saving ? null : saveReply,
              ),
            ),

            const SizedBox(height: 20),

            if ((data['reply'] ?? '')
                .toString()
                .isNotEmpty)
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding:
                  const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Current Reply",
                        style: TextStyle(
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        data['reply'],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
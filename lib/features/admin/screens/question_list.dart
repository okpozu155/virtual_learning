import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionList extends StatelessWidget {
  final String slideId;

  const QuestionList({
    super.key,
    required this.slideId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('quizzes')
          .doc(slideId)
          .collection('questions')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child:
            CircularProgressIndicator(),
          );
        }

        final docs =
            snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(
            child: Text(
              "No Questions Yet",
            ),
          );
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder:
              (context, index) {
            final question =
            docs[index];

            return Card(
              margin:
              const EdgeInsets.all(
                8,
              ),
              child: ListTile(
                title: Text(
                  question['question'],
                ),
                subtitle: Text(
                  "Correct Answer: ${question['correctAnswer']}",
                ),
                trailing: Row(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                      ),
                      onPressed: () async {
                        await question
                            .reference
                            .delete();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
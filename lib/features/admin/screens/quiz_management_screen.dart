import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'question_list.dart';
import 'add_question_screen.dart';

class QuizManagementScreen extends StatefulWidget {
  const QuizManagementScreen({super.key});

  @override
  State<QuizManagementScreen> createState() =>
      _QuizManagementScreenState();
}

class _QuizManagementScreenState
    extends State<QuizManagementScreen> {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  String? selectedSlideId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz Management"),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection('slides')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                );
              }

              final slides = snapshot.data!.docs;

              return Padding(
                padding: const EdgeInsets.all(16),
                child: DropdownButtonFormField<String>(
                  value: selectedSlideId,
                  hint: const Text(
                    "Select Slide",
                  ),
                  items: slides.map((doc) {
                    final data =
                    doc.data()
                    as Map<String, dynamic>;

                    return DropdownMenuItem(
                      value: doc.id,
                      child: Text(
                        data['title'] ??
                            doc.id,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSlideId =
                          value;
                    });
                  },
                ),
              );
            },
          ),

          if (selectedSlideId != null)
            Expanded(
              child: QuestionList(
                slideId: selectedSlideId!,
              ),
            ),
        ],
      ),
      floatingActionButton:
      selectedSlideId == null
          ? null
          : FloatingActionButton(
        child: const Icon(
          Icons.add,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  AddQuestionScreen(
                    slideId:
                    selectedSlideId!,
                  ),
            ),
          );
        },
      ),
    );
  }
}
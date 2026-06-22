import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddQuestionScreen extends StatefulWidget {
  final String slideId;

  const AddQuestionScreen({
    super.key,
    required this.slideId,
  });

  @override
  State<AddQuestionScreen> createState() =>
      _AddQuestionScreenState();
}

class _AddQuestionScreenState
    extends State<AddQuestionScreen> {
  final questionController =
  TextEditingController();

  final optionA =
  TextEditingController();

  final optionB =
  TextEditingController();

  final optionC =
  TextEditingController();

  final optionD =
  TextEditingController();

  final explanationController =
  TextEditingController();

  int correctAnswer = 0;

  Future<void> saveQuestion() async {
    await FirebaseFirestore.instance
        .collection('quizzes')
        .doc(widget.slideId)
        .collection('questions')
        .add({
      'question':
      questionController.text.trim(),

      'options': [
        optionA.text.trim(),
        optionB.text.trim(),
        optionC.text.trim(),
        optionD.text.trim(),
      ],

      'correctAnswer':
      correctAnswer,

      'explanation':
      explanationController.text.trim(),

      'createdAt':
      FieldValue.serverTimestamp(),
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Widget buildField(
      String label,
      TextEditingController c) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          border:
          const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(title: const Text(
        "Add Question",
      )),
      body: SingleChildScrollView(
        padding:
        const EdgeInsets.all(16),
        child: Column(
          children: [
            buildField(
              "Question",
              questionController,
            ),

            buildField(
              "Option A",
              optionA,
            ),

            buildField(
              "Option B",
              optionB,
            ),

            buildField(
              "Option C",
              optionC,
            ),

            buildField(
              "Option D",
              optionD,
            ),

            DropdownButtonFormField<int>(
              value: correctAnswer,
              decoration:
              const InputDecoration(
                labelText:
                "Correct Answer",
              ),
              items: const [
                DropdownMenuItem(
                  value: 0,
                  child: Text("A"),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text("B"),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text("C"),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Text("D"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  correctAnswer =
                      value ?? 0;
                });
              },
            ),

            const SizedBox(height: 16),

            buildField(
              "Explanation",
              explanationController,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: saveQuestion,
              child: const Text(
                "Save Question",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
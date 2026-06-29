import 'package:flutter/material.dart';

import '../../../data/models/quiz_model.dart';
import '../../../data/models/question_model.dart';
import '../../../data/repositories/quiz_repository.dart';
import '../../../core/services/progress_service.dart';

class QuizScreen extends StatefulWidget {
  final String slideId;

  const QuizScreen({super.key, required this.slideId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizRepository repository = QuizRepository();

  QuizModel? quiz;

  int currentIndex = 0;
  int score = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    debugPrint("Quiz opened for slide: ${widget.slideId}");
    loadQuiz();
  }

  Future<void> loadQuiz() async {
    try {
      final loadedQuiz = await repository.getQuizBySlideId(widget.slideId);

      if (!mounted) return;

      setState(() {
        quiz = loadedQuiz;
        loading = false;
      });
    } catch (e) {
      debugPrint("Quiz error: $e");

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> answerQuestion(int selectedIndex) async {
    final question = quiz!.questions[currentIndex];

    if (selectedIndex == question.correctAnswer) {
      score++;
    }

    if (currentIndex < quiz!.questions.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      final percentage = ((score / quiz!.questions.length) * 100).round();

      await ProgressService.saveProgress(widget.slideId, percentage);

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Quiz Complete"),
          content: Text("Score: $score / ${quiz!.questions.length}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, true);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (quiz == null) {
      return const Scaffold(
        body: Center(
          child: Text("No quiz available", style: TextStyle(fontSize: 18)),
        ),
      );
    }

    if (quiz!.questions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text("No questions found", style: TextStyle(fontSize: 18)),
        ),
      );
    }

    final QuestionModel question = quiz!.questions[currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text(quiz?.title ?? "Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (currentIndex + 1) / quiz!.questions.length,
            ),

            const SizedBox(height: 20),

            Text(
              question.question,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            ...question.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => answerQuestion(index),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30,
                          child: Text(
                            String.fromCharCode(65 + index),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            option,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

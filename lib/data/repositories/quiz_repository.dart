import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/quiz_model.dart';

class QuizRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QuizModel>> getQuizzes() async {
    final snapshot = await _firestore.collection('quizzes').get();

    final quizzes = <QuizModel>[];

    for (final doc in snapshot.docs) {
      final quiz = await _quizFromDocument(doc);

      if (quiz.questions.isNotEmpty) {
        quizzes.add(quiz);
      }
    }

    return quizzes;
  }

  Future<QuizModel?> getQuizBySlideId(String slideId) async {
    final doc = await _firestore.collection('quizzes').doc(slideId).get();

    if (!doc.exists) {
      return null;
    }

    final quiz = await _quizFromDocument(doc);

    if (quiz.questions.isEmpty) {
      return null;
    }

    return quiz;
  }

  Future<QuizModel> _quizFromDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) async {
    final data = doc.data() ?? {};
    final questionsSnapshot = await doc.reference
        .collection('questions')
        .orderBy('createdAt')
        .get();

    final questions = questionsSnapshot.docs
        .map((questionDoc) => questionDoc.data())
        .toList();

    return QuizModel.fromJson({
      'slideId': data['slideId'] ?? doc.id,
      'title': data['title'] ?? 'Quiz',
      'questions': questions,
    });
  }
}

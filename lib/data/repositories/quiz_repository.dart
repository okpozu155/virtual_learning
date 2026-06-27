import 'package:flutter/material.dart';
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
    debugPrint("Looking for quiz for slideId = $slideId");

    final doc =
    await _firestore.collection('quizzes').doc(slideId).get();

    debugPrint("Document exists? ${doc.exists}");

    if (doc.exists) {
      debugPrint("Document data:");
      debugPrint(doc.data().toString());

      final quiz = await _quizFromDocument(doc);

      debugPrint("Questions loaded: ${quiz.questions.length}");

      if (quiz.questions.isNotEmpty) {
        return quiz;
      }
    }

    debugPrint("Trying slideId query...");

    final snapshot = await _firestore
        .collection('quizzes')
        .where('slideId', isEqualTo: slideId)
        .limit(1)
        .get();

    debugPrint("Query returned ${snapshot.docs.length} docs");

    if (snapshot.docs.isEmpty) {
      return null;
    }

    debugPrint(snapshot.docs.first.data().toString());

    final quiz = await _quizFromDocument(snapshot.docs.first);

    debugPrint("Questions after parsing: ${quiz.questions.length}");

    return quiz.questions.isEmpty ? null : quiz;
  }

  Future<QuizModel> _quizFromDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) async {
    final data = doc.data() ?? {};
    final questions = await _questionsFromDocument(doc, data);

    return QuizModel.fromJson({
      'slideId': data['slideId'] ?? doc.id,
      'title': data['title'] ?? 'Quiz',
      'questions': questions,
    });
  }

  Future<List<Map<String, dynamic>>> _questionsFromDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
    Map<String, dynamic> data,
  ) async {
    final embeddedQuestions = data['questions'];

    if (embeddedQuestions is List && embeddedQuestions.isNotEmpty) {
      return embeddedQuestions
          .whereType<Map>()
          .map((question) => Map<String, dynamic>.from(question))
          .toList();
    }

    final questionsSnapshot = await doc.reference.collection('questions').get();
    final questionDocs = [...questionsSnapshot.docs];

    questionDocs.sort((a, b) {
      final aCreatedAt = a.data()['createdAt'];
      final bCreatedAt = b.data()['createdAt'];

      if (aCreatedAt is Timestamp && bCreatedAt is Timestamp) {
        return aCreatedAt.compareTo(bCreatedAt);
      }

      return a.id.compareTo(b.id);
    });

    return questionDocs.map((questionDoc) => questionDoc.data()).toList();
  }
}

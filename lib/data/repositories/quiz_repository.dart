import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../models/quiz_model.dart';

class QuizRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QuizModel>> getQuizzes() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('quizzes')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return QuizModel.fromJson(data);
      }).toList();
    } catch (e) {
      print("Error fetching quizzes: $e");
      return [];
    }
  }

  Future<QuizModel?> getQuizBySlideId(String slideId) async {
    print("Looking for quiz with slideId: $slideId");

    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('quizzes')
          .where('slideId', isEqualTo: slideId)
          .get();

      if (snapshot.docs.isEmpty) {
        print("NO MATCH FOUND");
        return null;
      }

      final data = snapshot.docs.first.data() as Map<String, dynamic>;
      final quiz = QuizModel.fromJson(data);

      print("Quiz found: ${quiz.slideId}");
      return quiz;
    } catch (_) {
      print("NO MATCH FOUND");
      return null;
    }
  }
}
/*

  Future<List<QuizModel>> getQuizzes() async {
    final jsonString =
    await rootBundle.loadString(
      'assets/data/quizzes.json',
    );

    final List<dynamic> data =
    json.decode(jsonString);

    return data
        .map(
          (e) => QuizModel.fromJson(e),
    )
        .toList();
  }
  Future<QuizModel?> getQuizBySlideId(String slideId) async {
    final quizzes = await getQuizzes();

    print("Looking for quiz with slideId: $slideId");

    for (final quiz in quizzes) {
      print("Quiz found: ${quiz.slideId}");
    }

    try {
      return quizzes.firstWhere(
            (quiz) => quiz.slideId == slideId,
      );
    } catch (_) {
      print("NO MATCH FOUND");
      return null;
    }
  } */
import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/quiz_model.dart';

class QuizRepository {
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
  Future<QuizModel?> getQuizBySlideId(
      String slideId) async {
    final quizzes = await getQuizzes();

    try {
      return quizzes.firstWhere(
            (quiz) => quiz.slideId == slideId,
      );
    } catch (_) {
      return null;
    }
  }
}
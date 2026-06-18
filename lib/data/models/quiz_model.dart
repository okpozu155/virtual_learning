import 'question_model.dart';

class QuizModel {
  final String title;
  final String slideId;
  final List<QuestionModel> questions;

  QuizModel({
    required this.title,
    required this.slideId,
    required this.questions,
  });

  factory QuizModel.fromJson(
      Map<String, dynamic> json) {
    return QuizModel(
      title: json['title'],
      slideId: json['slideId'],
      questions:
      (json['questions'] as List)
          .map(
            (e) =>
            QuestionModel.fromJson(e),
      )
          .toList(),
    );
  }
}
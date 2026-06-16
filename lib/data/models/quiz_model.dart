import 'question_model.dart';

class QuizModel {
  final String id;
  final String title;
  final String slideId;
  final List<QuestionModel> questions;

  QuizModel({
    required this.id,
    required this.title,
    required this.slideId,
    required this.questions,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'],
      title: json['title'],
      slideId: json['slideId'],
      questions: (json['questions'] as List)
          .map((e) => QuestionModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slideId': slideId,
      'questions': questions.map((e) => e.toJson()).toList(),
    };
  }
}
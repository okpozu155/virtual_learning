class QuestionModel {
  final String question;
  final List<String> options;
  final int correctAnswer;

  QuestionModel({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuestionModel.fromJson(
      Map<String, dynamic> json) {
    return QuestionModel(
      question: json['question'],
      options:
      List<String>.from(json['options']),
      correctAnswer:
      json['correctAnswer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
    };
  }
}
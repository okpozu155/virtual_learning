class QuestionModel {
  final String question;
  final List<String> options;
  final int correctAnswer;

  QuestionModel({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      question: json['question']?.toString() ?? json['text']?.toString() ?? '',
      options: _parseOptions(json['options']),
      correctAnswer:
          (json['correctAnswer'] as num?)?.toInt() ??
          (json['correctIndex'] as num?)?.toInt() ??
          (json['answerIndex'] as num?)?.toInt() ??
          0,
    );
  }

  static List<String> _parseOptions(dynamic value) {
    if (value is List) {
      return value.map((option) => option.toString()).toList();
    }

    if (value is Map) {
      return ['A', 'B', 'C', 'D']
          .map((key) => value[key] ?? value[key.toLowerCase()])
          .where((option) => option != null)
          .map((option) => option.toString())
          .toList();
    }

    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
    };
  }
}

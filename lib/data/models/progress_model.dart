class ProgressModel {
  final int slidesViewed;
  final int quizzesTaken;
  final double averageScore;
  final int streakDays;

  ProgressModel({
    required this.slidesViewed,
    required this.quizzesTaken,
    required this.averageScore,
    required this.streakDays,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      slidesViewed: json['slidesViewed'],
      quizzesTaken: json['quizzesTaken'],
      averageScore: (json['averageScore'] as num).toDouble(),
      streakDays: json['streakDays'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slidesViewed': slidesViewed,
      'quizzesTaken': quizzesTaken,
      'averageScore': averageScore,
      'streakDays': streakDays,
    };
  }
}
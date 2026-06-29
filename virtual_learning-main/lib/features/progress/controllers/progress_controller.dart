import '../../../data/models/progress_model.dart';
import '../../../data/repositories/progress_repository.dart';

class ProgressController {
  final ProgressRepository repository =
  ProgressRepository();

  Stream<ProgressModel> getProgress(
      String userId,
      ) {
    return repository.progressStream(userId);
  }

  double calculateOverallProgress(
      ProgressModel progress,
      ) {
    double score = 0;

    score += progress.slidesViewed * 2;
    score += progress.quizzesTaken * 3;
    score += progress.averageScore * 0.4;
    score += progress.streakDays * 2;

    if (score > 100) {
      score = 100;
    }

    return score;
  }
}
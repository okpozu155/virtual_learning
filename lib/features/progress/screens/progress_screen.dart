import 'package:flutter/material.dart';




import '../../../data/models/progress_model.dart';
import '../../../data/repositories/progress_repository.dart';
import '../../authentication/controllers/auth_controller.dart';

class ProgressScreen extends StatelessWidget {
  ProgressScreen({super.key});

  final AuthController _authController = AuthController();
  final ProgressRepository _progressRepository =
  ProgressRepository();

  @override
  Widget build(BuildContext context) {
    final user = _authController.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('No user logged in'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Progress'),
        centerTitle: true,
      ),
      body: StreamBuilder<ProgressModel>(
        stream: _progressRepository.progressStream(
          user.uid,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('No progress data available'),
            );
          }

          final progress = snapshot.data!;

          final overallProgress =
          _calculateOverallProgress(progress);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 10),

                /// Profile Header
                CircleAvatar(
                  radius: 45,
                  child: Text(
                    user.email![0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  user.displayName ?? 'Student',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  user.email ?? '',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 30),

                /// Overall Progress
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'Overall Progress',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: overallProgress / 100,
                            strokeWidth: 10,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          '${overallProgress.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// Statistics
                GridView.count(
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _statCard(
                      title: 'Slides Viewed',
                      value:
                      '${progress.slidesViewed}',
                      icon: Icons.image,
                    ),
                    _statCard(
                      title: 'Quizzes Taken',
                      value:
                      '${progress.quizzesTaken}',
                      icon: Icons.quiz,
                    ),
                    _statCard(
                      title: 'Average Score',
                      value:
                      '${progress.averageScore.toStringAsFixed(0)}%',
                      icon: Icons.bar_chart,
                    ),
                    _statCard(
                      title: 'Study Streak',
                      value:
                      '${progress.streakDays} Days',
                      icon: Icons.local_fire_department,
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                /// Achievement Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'Achievements',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        ListTile(
                          leading: const Icon(
                            Icons.emoji_events,
                          ),
                          title:
                          const Text('First Slide Viewed'),
                          trailing: Icon(
                            progress.slidesViewed > 0
                                ? Icons.check_circle
                                : Icons.lock,
                          ),
                        ),

                        ListTile(
                          leading: const Icon(
                            Icons.emoji_events,
                          ),
                          title:
                          const Text('Completed 10 Quizzes'),
                          trailing: Icon(
                            progress.quizzesTaken >= 10
                                ? Icons.check_circle
                                : Icons.lock,
                          ),
                        ),

                        ListTile(
                          leading: const Icon(
                            Icons.emoji_events,
                          ),
                          title:
                          const Text('Score Above 80%'),
                          trailing: Icon(
                            progress.averageScore >= 80
                                ? Icons.check_circle
                                : Icons.lock,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  double _calculateOverallProgress(
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

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 35,
            ),

            const SizedBox(height: 10),

            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              title,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
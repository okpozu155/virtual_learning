import 'package:flutter/material.dart';

import '../../../data/models/progress_model.dart';
import '../../../data/repositories/progress_repository.dart';
import '../../authentication/controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final AuthController authController =
  AuthController();

  final ProgressRepository progressRepository =
  ProgressRepository();

  @override
  Widget build(BuildContext context) {
    final user = authController.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('No user logged in'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: StreamBuilder<ProgressModel>(
        stream: progressRepository.progressStream(
          user.uid,
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final progress = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 55,
                  child: Text(
                    user.email![0].toUpperCase(),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  user.displayName ?? 'Student',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(user.email ?? ''),

                const SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: 'Slides Viewed',
                        value:
                        '${progress.slidesViewed}',
                        icon: Icons.image,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildStatCard(
                        title: 'Quizzes',
                        value:
                        '${progress.quizzesTaken}',
                        icon: Icons.quiz,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: 'Average Score',
                        value:
                        '${progress.averageScore.toStringAsFixed(0)}%',
                        icon: Icons.bar_chart,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildStatCard(
                        title: 'Streak',
                        value:
                        '${progress.streakDays} Days',
                        icon: Icons.local_fire_department,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}
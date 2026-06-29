import 'package:flutter/material.dart';

class QuizResultScreen extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;
  final String timeTaken;

  const QuizResultScreen({
    super.key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.timeTaken,
  });

  @override
  Widget build(BuildContext context) {
    final double scorePercentage =
        (correctAnswers / totalQuestions) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz Result"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            const SizedBox(height: 20),

            CircleAvatar(
              radius: 70,
              backgroundColor: Colors.green.shade100,
              child: Text(
                "${scorePercentage.toInt()}%",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Great Job!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "You answered $correctAnswers out of $totalQuestions questions correctly.",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            Row(
              children: [

                Expanded(
                  child: _buildStatCard(
                    title: "Correct",
                    value: correctAnswers.toString(),
                    color: Colors.green,
                    icon: Icons.check_circle,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildStatCard(
                    title: "Incorrect",
                    value: incorrectAnswers.toString(),
                    color: Colors.red,
                    icon: Icons.cancel,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _buildStatCard(
              title: "Time Taken",
              value: timeTaken,
              color: Colors.blue,
              icon: Icons.timer,
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to Review Screen
                },
                child: const Text(
                  "Review Answers",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Back to Dashboard",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [

            Icon(
              icon,
              size: 35,
              color: color,
            ),

            const SizedBox(height: 10),

            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),

            const SizedBox(height: 5),

            Text(title),
          ],
        ),
      ),
    );
  }
}
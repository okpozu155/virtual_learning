import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            Text(
              "Overall Progress",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            LinearProgressIndicator(
              value: 0.75,
              minHeight: 10,
            ),
            SizedBox(height: 10),
            Text("75% Completed"),
          ],
        ),
      ),
    );
  }
}
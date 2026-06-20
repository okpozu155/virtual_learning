import 'package:flutter/material.dart';

class QuizManagementScreen extends StatelessWidget {
  const QuizManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Management')),
      body: const Center(
        child: Text('Quiz Management Screen'),
      ),
    );
  }
}
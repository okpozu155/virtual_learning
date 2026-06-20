import 'package:flutter/material.dart';

class AchievementTile extends StatelessWidget {
  final String title;
  final bool achieved;

  const AchievementTile({
    super.key,
    required this.title,
    required this.achieved,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.emoji_events,
      ),
      title: Text(title),
      trailing: Icon(
        achieved
            ? Icons.check_circle
            : Icons.lock,
      ),
    );
  }
}
import 'package:flutter/material.dart';

class MicroscopeToolbar extends StatelessWidget {
  final VoidCallback onNotesTap;
  final VoidCallback onQuizTap;
  final VoidCallback onAiTap;

  const MicroscopeToolbar({
    super.key,
    required this.onNotesTap,
    required this.onQuizTap,
    required this.onAiTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceAround,
        children: [
          _toolbarItem(
            icon: Icons.note_alt_outlined,
            title: "Hotspot Notes",
            onTap: onNotesTap,
          ),

          _toolbarItem(
            icon: Icons.quiz_outlined,
            title: "Quiz",
            onTap: onQuizTap,
          ),

          _toolbarItem(
            icon: Icons.smart_toy_outlined,
            title: "Ask AI",
            onTap: onAiTap,
          ),
        ],
      ),
    );
  }

  Widget _toolbarItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
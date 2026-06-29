import 'package:flutter/material.dart';

class ProgressHeader extends StatelessWidget {
  final String name;
  final String email;

  const ProgressHeader({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          child: Text(
            email.isNotEmpty
                ? email[0].toUpperCase()
                : 'S',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 12),

        Text(
          name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          email,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
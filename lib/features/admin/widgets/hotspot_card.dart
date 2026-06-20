import 'package:flutter/material.dart';

class HotspotCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onDelete;

  const HotspotCard({
    super.key,
    required this.title,
    required this.description,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
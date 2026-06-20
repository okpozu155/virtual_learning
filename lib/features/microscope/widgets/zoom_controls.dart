import 'package:flutter/material.dart';

class ZoomControls extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onReset;

  const ZoomControls({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black87,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 6,
        ),
        child: Column(
          children: [
            IconButton(
              onPressed: onZoomIn,
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),

            IconButton(
              onPressed: onZoomOut,
              icon: const Icon(
                Icons.remove,
                color: Colors.white,
              ),
            ),

            TextButton(
              onPressed: onReset,
              child: const Text(
                'Reset',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
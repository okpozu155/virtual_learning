import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  final String imagePath;
  final TransformationController transformationController;

  const ImageViewer({
    super.key,
    required this.imagePath,
    required this.transformationController,
  });

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: transformationController,
      minScale: 1,
      maxScale: 10,
      boundaryMargin: const EdgeInsets.all(100),
      child: Center(
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
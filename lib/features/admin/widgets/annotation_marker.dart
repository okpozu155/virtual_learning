import 'package:flutter/material.dart';

class AnnotationMarker extends StatelessWidget {
  final double x;
  final double y;
  final VoidCallback? onTap;

  const AnnotationMarker({
    super.key,
    required this.x,
    required this.y,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x * MediaQuery.of(context).size.width,
      top: y * MediaQuery.of(context).size.height,
      child: GestureDetector(
        onTap: onTap,
        child: const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 35,
        ),
      ),
    );
  }
}
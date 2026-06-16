import 'package:flutter/material.dart';

class HotspotMarker extends StatelessWidget {
  final dynamic hotspot;
  final VoidCallback onTap;

  const HotspotMarker({
    super.key,
    required this.hotspot,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: hotspot.x,
      top: hotspot.y,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../data/models/hotspot_model.dart';

class HotspotMarker extends StatelessWidget {

  final HotspotModel hotspot;
  final VoidCallback onTap;

  const HotspotMarker({
    super.key,
    required this.hotspot,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: hotspot.x * MediaQuery.of(context).size.width,
      top: hotspot.y * MediaQuery.of(context).size.height,
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
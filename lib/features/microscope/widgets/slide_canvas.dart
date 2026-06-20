import 'package:flutter/material.dart';
import '../../../data/models/hotspot_model.dart';

class SlideCanvas extends StatelessWidget {
  final String imagePath;
  final TransformationController transformationController;
  final List<HotspotModel> hotspots;
  final Function(HotspotModel) onHotspotTap;

  const SlideCanvas({
    super.key,
    required this.imagePath,
    required this.transformationController,
    required this.hotspots,
    required this.onHotspotTap,
  });

  @override
  Widget build(BuildContext context) {
    const double iconSize = 30.0; // Defined as a constant to calculate the alignment offset

    return InteractiveViewer(
      transformationController: transformationController,
      minScale: 1,
      maxScale: 10,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),

              ...hotspots.map(
                    (hotspot) => Positioned(
                  // FIXED: Subtract half of the icon size so the icon's exact center aligns with the coordinate
                  left: (hotspot.x * constraints.maxWidth) - (iconSize / 2),
                  top: (hotspot.y * constraints.maxHeight) - (iconSize / 2),
                  child: GestureDetector(
                    onTap: () => onHotspotTap(hotspot),
                    child: const Icon(
                      Icons.location_on,
                      size: iconSize,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
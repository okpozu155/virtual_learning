import 'package:flutter/material.dart';

import '../controllers/microscope_controller.dart';
import '../widgets/image_viewer.dart';
import '../widgets/hotspot_marker.dart';
import '../widgets/zoom_controls.dart';

class MicroscopeScreen extends StatefulWidget {
  const MicroscopeScreen({super.key});

  @override
  State<MicroscopeScreen> createState() => _MicroscopeScreenState();
}

class _MicroscopeScreenState extends State<MicroscopeScreen> {
  final MicroscopeController controller = MicroscopeController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _showHotspotInfo(dynamic hotspot) {
    Navigator.pushNamed(
      context,
      '/hotspot-info',
      arguments: hotspot,
    );
  }

  void _openQuiz() {
    Navigator.pushNamed(context, '/quiz');
  }

  void _openAITutor() {
    Navigator.pushNamed(context, '/ai-tutor');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            /// Microscope Image
            Positioned.fill(
              child: ImageViewer(
                imagePath: controller.slideImage,
                transformationController:
                controller.transformationController,
              ),
            ),

            /// Hotspots
            ...controller.hotspots.map(
                  (hotspot) => HotspotMarker(
                hotspot: hotspot,
                onTap: () => _showHotspotInfo(hotspot),
              ),
            ),

            /// Header
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Blood Microscopy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            /// Zoom Controls
            Positioned(
              right: 16,
              top: 100,
              child: ZoomControls(
                onZoomIn: controller.zoomIn,
                onZoomOut: controller.zoomOut,
                onReset: controller.resetZoom,
              ),
            ),

            /// Bottom Toolbar
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
                  children: [
                    _actionButton(
                      icon: Icons.note_alt_outlined,
                      label: "Hotspot Notes",
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/hotspot-info',
                        );
                      },
                    ),

                    _actionButton(
                      icon: Icons.quiz_outlined,
                      label: "Quiz",
                      onTap: _openQuiz,
                    ),

                    _actionButton(
                      icon: Icons.smart_toy_outlined,
                      label: "Ask AI",
                      onTap: _openAITutor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
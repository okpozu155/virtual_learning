import 'package:flutter/material.dart';
import '../controllers/microscope_controller.dart';

import '../widgets/zoom_controls.dart';
import '../../../features/quiz/screens/quiz_screen.dart';
import '../../../data/models/slide_model.dart';
import '../../../data/models/hotspot_model.dart';
import '../../../data/repositories/hotspot_repository.dart';
import '../widgets/slide_canvas.dart';


class MicroscopeScreen extends StatefulWidget {
  final SlideModel slide;

  const MicroscopeScreen({
    super.key,
    required this.slide,
  });

  @override
  State<MicroscopeScreen> createState() => _MicroscopeScreenState();
}

class _MicroscopeScreenState extends State<MicroscopeScreen> {
  final MicroscopeController controller = MicroscopeController();

  final HotspotRepository hotspotRepository =
  HotspotRepository();

  @override
  void initState() {
    super.initState();
    loadHotspots();
  }


  Future<void> loadHotspots() async {
    controller.hotspots =
    await hotspotRepository.getHotspots(
      widget.slide.id,
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _showHotspotInfo(HotspotModel hotspot) {
    Navigator.pushNamed(
      context,
      '/hotspot-info',
      arguments: hotspot,
    );
  }

  void _openAITutor() {
    Navigator.pushNamed(
      context,
      '/ai-tutor',
    );
  }



  @override
  Widget build(BuildContext context) {

    debugPrint(
      "Slide ID = ${widget.slide.id}",
    );

    debugPrint(
      "Slide title = ${widget.slide.title}",
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(.85),
        elevation: 0,
        title: Text(
          widget.slide.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            /// Microscope Image
            Positioned.fill(
              child: SlideCanvas(
                imagePath: widget.slide.imageUrl,
                transformationController:
                controller.transformationController,
                hotspots: controller.hotspots
                    .cast<HotspotModel>(),
                onHotspotTap: _showHotspotInfo,
              ),
            ),

            /// Zoom Controls
            Positioned(
              right: 16,
              top: 20,
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
              child: SizedBox(
                height: 90,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.7),
                    borderRadius:
                    BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                    children: [
                      _actionButton(
                        icon: Icons.note_alt_outlined,
                        label: "Hotspot Notes",
                        onTap: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Tap a hotspot marker on the slide to view its information.',
                              ),
                            ),
                          );
                        },
                      ),

                      _actionButton(
                        icon: Icons.quiz,
                        label: "Quiz",
                        onTap: () {

                          print(
                            "Opening quiz for slide: ${widget.slide.id}",
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuizScreen(
                                slideId: widget.slide.id,
                              ),
                            ),
                          );
                        },
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
              color: Colors.lightGreenAccent,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.greenAccent,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
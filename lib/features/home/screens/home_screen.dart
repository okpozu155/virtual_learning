import 'package:flutter/material.dart';

import '../widgets/dashboard_card.dart';
import '../widgets/progress_card.dart';
import '../widgets/quick_action_card.dart';

import '../../slide_library/screens/library_screen.dart';
import '../../microscope/screens/microscope_screen.dart';
import '../../quiz/screens/quiz_screen.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../data/repositories/slide_repository.dart';
import '../../../data/models/slide_model.dart';
import '../../../core/services/progress_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SlideRepository _repository = SlideRepository();
  List<SlideModel> allSlides = []; // Holds the slides used in your progress calculations

  double overallProgress = 0;
  Future<void> loadOverallProgress() async {
    overallProgress =
    await ProgressService.getOverallProgress(
      allSlides.map((e) => e.id).toList(),
    );
    Future<void> loadOverallProgress() async {
      overallProgress =
      await ProgressService.getOverallProgress(
        allSlides.map((e) => e.id).toList(),
      );
      debugPrint(
        "Overall Progress = $overallProgress",
      );


      if (mounted) {
        setState(() {});
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSlidesData();
  }

  /// Fetches slides from the repository to supply data for calculateOverallProgress
  Future<void> _loadSlidesData() async {
    try {
      // Assuming your repository has a method to get all slides (e.g., getSlides or fetchAll)
      // Adjust this method call name to match your exact SlideRepository implementation
      final slides = await _repository.getSlides();

      setState(() {
        allSlides = slides;
      });
      await loadOverallProgress();
    } catch (e) {
      // Fail silently or handle error appropriately
    }
  }

  Future<void> openMicroscope() async {
    final storage = LocalStorageService();

    final slideId = await storage.getLastViewedSlide();

    if (slideId == null) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text(
            'No Slide Selected',
          ),
          content: const Text(
            'Please go to the Slide Library and choose a slide first.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

      return;

    }

    final slide = await _repository.getSlideById(slideId);

    if (slide == null) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'The previously viewed slide could not be found.',
          ),
        ),
      );

      return;
    }

    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MicroscopeScreen(
          slide: slide,
        ),
      ),
    );

    await loadOverallProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Virtual Learn"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {Navigator.pushNamed(
              context,
              AppRoutes.adminDashboard,
            );
              },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome Back 👋",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
                "Continue your microscopy journey",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDC3F3F),
                )
            ),

            const SizedBox(height: 20),

            ProgressCard(
              progress: overallProgress,
            ),
            const SizedBox(height: 25),

            const Text(
              "Quick Access",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                DashboardCard(
                  title: "Library",
                  icon: Icons.menu_book,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LibraryScreen(),
                      ),
                    );
                  },
                ),

                DashboardCard(
                  title: "Microscope",
                  icon: Icons.biotech,
                  color: Colors.green,
                  onTap: openMicroscope,
                ),

                DashboardCard(
                  title: "Quiz",
                  icon: Icons.quiz,
                  color: Colors.purple,
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  QuickActionCard(
                    title: "Library",
                    icon: Icons.menu_book,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LibraryScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 12),

                  QuickActionCard(
                    title: "Microscope",
                    icon: Icons.biotech,
                    color: Colors.green,
                    onTap: openMicroscope,
                  ),

                  const SizedBox(width: 12),

                  QuickActionCard(
                    title: "Quiz",
                    icon: Icons.quiz,
                    color: Colors.purple,
                    onTap: () {},
                  ),

                  const SizedBox(width: 12),

                  QuickActionCard(
                    title: "Progress",
                    icon: Icons.bar_chart,
                    color: Colors.red,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.local_fire_department,
                ),
                title: const Text(
                  "Current Streak",
                ),
                subtitle: const Text(
                  "5 Days",
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Progress",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "profile",
          ),
        ],
      ),
    );
  }
}
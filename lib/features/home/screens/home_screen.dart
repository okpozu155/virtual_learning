import 'package:flutter/material.dart';

import '../widgets/dashboard_card.dart';

import '../../../features/profile/screens/student_profile_screen.dart';
import '../../../features/progress/screens/recent_topics_screen.dart';

import '../../../message/message_admin_screen.dart';

import '../../../message/student_bulletin_screen.dart';
import '../../../message/student_inbox_screen.dart';

import '../../slide_library/screens/library_screen.dart';
import '../../microscope/screens/microscope_screen.dart';
import '../../quiz/screens/quiz_screen.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/services/progress_service.dart';
import '../../../core/theme/character_animation.dart';

import '../../../data/models/slide_model.dart';
import '../../../data/repositories/slide_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  final SlideRepository _repository = SlideRepository();

  List<SlideModel> allSlides = [];

  double overallProgress = 0;


  @override
  void initState() {
    super.initState();
    _loadSlidesData();
  }

  Future<void> loadOverallProgress() async {
    overallProgress = await ProgressService.getOverallProgress(
      allSlides.map((e) => e.id).toList(),
    );

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadSlidesData() async {
    try {
      final slides = await _repository.getSlides();

      setState(() {
        allSlides = slides;
      });

      await loadOverallProgress();
    } catch (e) {
      debugPrint("Error loading slides: $e");
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
          title: const Text('No Slide Selected'),
          content: const Text(
            'Please go to the Slide Library and choose a slide first.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
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

  Future<void> openLastQuiz() async {
    final slideId =
    await LocalStorageService().getLastViewedSlide();

    if (slideId == null) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "No slide viewed yet.",
          ),
        ),
      );
      return;
    }

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          slideId: slideId,
        ),
      ),
    );
  }

  void _showStudentMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Student Menu",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("My Profile"),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const StudentProfileScreen(),
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.message),
                  title: const Text("Messages"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StudentInboxScreen(),
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.campaign),
                  title: const Text("Bulletins"),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const StudentBulletinScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Virtual Learn"),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () {
              Navigator.pushNamed(
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

            const CharacterAnimation(
              text: "Continue your microscopy journey",
              color: Color(0xFF239C16),
            ),



            const SizedBox(height: 20),

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
              physics:
              const NeverScrollableScrollPhysics(),
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
                        builder: (_) =>
                        const LibraryScreen(),
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
                  onTap: openLastQuiz,
                ),
              ],
            ),

            const SizedBox(height: 25),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.local_fire_department,
                ),
                title: const Text(
                  "Recent Topics",
                ),
                subtitle: const Text(
                  "Last 7 slides viewed",
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const RecentTopicsScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.school),
                  label: const Text("Student"),
                  onPressed: () {
                    _showStudentMenu(context);
                  },
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.message),
                  label: const Text("Admin"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const MessageAdminScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
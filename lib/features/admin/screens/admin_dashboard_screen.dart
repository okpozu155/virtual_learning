import 'package:flutter/material.dart';


import 'package:virtual_learning/features/admin/screens/slide_management_screen.dart';
import 'package:virtual_learning/features/admin/screens/annotation_editor_screen.dart';
import 'package:virtual_learning/features/admin/screens/hotspot_list_screen.dart';
import 'package:virtual_learning/features/admin/screens/quiz_management_screen.dart';
import 'package:virtual_learning/features/admin/screens/analytics_screen.dart';



class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'title': 'Upload Slide',
        'icon': Icons.upload_file,
        'route': '/slide-management',
      },
      {
        'title': 'Annotate Slide',
        'icon': Icons.edit_location_alt,
        'route': '/annotation-editor',
      },
      {
        'title': 'Manage Hotspots',
        'icon': Icons.place,
        'route': '/hotspot-list',
      },
      {
        'title': 'Manage Quizzes',
        'icon': Icons.quiz,
        'route': '/quiz-management',
      },
      {
        'title': 'Analytics',
        'icon': Icons.bar_chart,
        'route': '/analytics',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final Map<String, dynamic> item = items[index];

            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                switch (item['title']) {
                  case 'Upload Slide':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SlideManagementScreen(),
                      ),
                    );
                    break;

                  case 'Manage Quizzes':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QuizManagementScreen(),
                      ),
                    );
                    break;

                  case 'Analytics':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AnalyticsScreen(),
                      ),
                    );
                    break;

                  case 'Annotate Slide':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SlideManagementScreen(),
                      ),
                    );
                    break;

                  case 'Manage Hotspots':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SlideManagementScreen(),
                      ),
                    );
                    break;
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.cyanAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item['icon'],
                      size: 50,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item['title'],
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
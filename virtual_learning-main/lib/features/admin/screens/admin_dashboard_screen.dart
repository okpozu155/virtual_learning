import 'package:flutter/material.dart';

import '/features/admin/screens/slide_management_screen.dart';

import '/features/admin/screens/quiz_management_screen.dart';
import '/features/admin/screens/analytics_screen.dart';

import '../../../message/admin_inbox_screen.dart';
import '../../../message/admin_bulletin_screen.dart';


class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'title': 'Upload Slide',
        'icon': Icons.upload_file,
        'route': '/slide-management',
        'color': Colors.cyanAccent,
      },
      {
        'title': 'Manage Quizzes',
        'icon': Icons.quiz,
        'route': '/quiz-management',
        'color': Colors.cyanAccent,
      },
      {
        'title': 'Analytics',
        'icon': Icons.bar_chart,
        'route': '/analytics',
        'color': Colors.cyanAccent,
      },
      {
        'title': 'Inbox',
        'icon': Icons.mail,
        'route': '/inbox',
        'color': Colors.blue,
      },
      {
        'title': 'Bulletins',
        'icon': Icons.campaign,
        'route': '/bulletins',
        'color': Colors.orange,
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

                  case 'Inbox':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminInboxScreen(),
                      ),
                    );
                    break;

                  case 'Bulletins':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminBulletinScreen(),
                      ),
                    );
                    break;
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: item['color'],
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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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


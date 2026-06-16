import 'package:flutter/material.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/progress_card.dart';
import '../widgets/quick_action_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Virtual Learn"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
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
            ),

            const SizedBox(height: 20),

            const ProgressCard(),

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
                  onTap: () {},
                ),
                DashboardCard(
                  title: "Microscope",
                  icon: Icons.biotech,
                  color: Colors.green,
                  onTap: () {},
                ),
                DashboardCard(
                  title: "AI Tutor",
                  icon: Icons.smart_toy,
                  color: Colors.orange,
                  onTap: () {},
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
                    onTap: () {},
                  ),

                  const SizedBox(width: 12),

                  QuickActionCard(
                    title: "Microscope",
                    icon: Icons.biotech,
                    color: Colors.green,
                    onTap: () {},
                  ),

                  const SizedBox(width: 12),

                  QuickActionCard(
                    title: "AI Tutor",
                    icon: Icons.smart_toy,
                    color: Colors.orange,
                    onTap: () {},
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
                leading: const Icon(Icons.local_fire_department),
                title: const Text("Current Streak"),
                subtitle: const Text("5 Days"),
                trailing: const Icon(Icons.arrow_forward_ios),
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
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
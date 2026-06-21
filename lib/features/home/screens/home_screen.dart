import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../profile/screens/profile_screen.dart'; // Import Profile Screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const Color slatePrimary = Color(0xFF3B5866);
  static const Color deepCharcoal = Color(0xFF0F172A);
  static const Color slateText = Color(0xFF64748B);
  static const Color premiumBg = Color(0xFFF8FAFC);
  static const Color cardBorder = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    // 🗂️ Live Navigation Stack Mapping
    final List<Widget> navTabs = [
      _buildDashboardView(context),
      _buildProgressPlaceholder(),
      const ProfileScreen(), // 👤 Injected Live Profile UI Screen
    ];

    return Scaffold(
      backgroundColor: premiumBg,
      appBar: AppBar(
        backgroundColor: premiumBg,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          _currentIndex == 0 ? "Virtual Learn" : _currentIndex == 1 ? "Progress Metrics" : "Profile Center",
          style: const TextStyle(color: deepCharcoal, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => setState(() => _currentIndex = 2), // Drop directly into profile tab
              child: CircleAvatar(
                backgroundColor: slatePrimary.withOpacity(0.1),
                child: const Icon(Icons.person_outline_rounded, color: slatePrimary),
              ),
            ),
          ),
        ],
      ),

      // IndexedStack protects execution state and data context values across switches
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: navTabs,
        ),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: cardBorder.withOpacity(0.5))),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: slatePrimary,
          unselectedItemColor: slateText.withOpacity(0.6),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Progress'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  // Isolated Dashboard Sub-View Structure
  Widget _buildDashboardView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Welcome Back 👋", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: deepCharcoal, letterSpacing: -0.5)),
          const SizedBox(height: 6),
          const Text("Continue your microscopy journey", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: slateText)),
          const SizedBox(height: 28),

          // Progress tracker matrix display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Overall Progress", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: deepCharcoal)),
                    Text("0% Completed", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: slatePrimary.withOpacity(0.8))),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const LinearProgressIndicator(
                    value: 0.0,
                    minHeight: 10,
                    backgroundColor: Color(0xFFF1F5F9),
                    valueColor: AlwaysStoppedAnimation<Color>(slatePrimary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text("Quick Access", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: deepCharcoal)),
          const SizedBox(height: 16),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
            children: [
              _buildDashboardCard(
                title: "Library",
                subtitle: "12 Modules",
                icon: Icons.auto_stories_rounded,
                accentColor: const Color(0xFF3B82F6),
                onTap: () {
                  // 🛫 Navigates seamlessly to your new full-view Slide Library!
                  Navigator.pushNamed(context, AppRoutes.library);
                },
              ),
              _buildDashboardCard(
                title: "Microscope",
                subtitle: "Interactive Lens",
                icon: Icons.biotech_rounded,
                accentColor: const Color(0xFF10B981),
                onTap: () => _showComingSoonToast(context, "Microscope Engine"),
              ),
              _buildDashboardCard(
                title: "Quiz",
                subtitle: "Test Skills",
                icon: Icons.quiz_rounded,
                accentColor: const Color(0xFF8B5CF6),
                onTap: () => _showComingSoonToast(context, "Quiz Module"),
              ),
              _buildDashboardCard(
                title: "Lab Logs",
                subtitle: "Saved Captures",
                icon: Icons.assignment_rounded,
                accentColor: const Color(0xFFF59E0B),
                onTap: () => _showComingSoonToast(context, "Lab Logs"),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProgressPlaceholder() {
    return Center(
      child: Text("Detailed Progress Visualizations Coming Soon", style: TextStyle(color: slateText, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: accentColor.withOpacity(0.08), borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: accentColor, size: 28),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: deepCharcoal)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: slateText)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoonToast(BuildContext context, String moduleName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$moduleName is currently under construction!"),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
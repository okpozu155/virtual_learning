import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/character_animation.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the custom Sky Blue palette
    const Color skyBluePrimary = Color.fromARGB(255, 59, 88, 102);
    const Color skyBlueLight = Color(0xffe6f4fa);
    const Color skyBlueDark = Color(0xff0077b6);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 22.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                // Welcome Illustration / Icon Holder
                Container(
                  height: 112,
                  width: 112,
                  decoration: const BoxDecoration(
                    color: skyBlueLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    size: 58,
                    color: skyBlueDark,
                  ),
                ),
                const SizedBox(height: 22),

                // Main Header
                CharacterAnimation(
                  text: 'Welcome to Virtual Learn',
                  color: const Color(0xFF0A2E5C), // Navy Blue
                ),


                // Subtitle
                const Text(
                  'Empowering your academic journey anytime, anywhere. Access your virtual MICROSCOPY.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 22),

                // Core Features Preview Cards
                _buildFeatureRow(
                  icon: Icons.auto_stories_rounded,
                  title: 'Interactive Slides',
                  subtitle: 'Learn from curated microscopic objects.',
                  iconColor: skyBlueDark,
                  bgColor: skyBlueLight,
                ),
                const SizedBox(height: 10),
                _buildFeatureRow(
                  icon: Icons.quiz_rounded,
                  title: 'Track Performance',
                  subtitle: 'Take assessments and view real-time statistics.',
                  iconColor: skyBlueDark,
                  bgColor: skyBlueLight,
                ),
                const SizedBox(height: 24),

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.signup,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: skyBluePrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.login,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: skyBluePrimary, width: 2),
                      foregroundColor: skyBlueDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'I already have an account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget to generate a sleek feature row
  Widget _buildFeatureRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

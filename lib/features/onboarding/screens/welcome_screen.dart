import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Theme Architecture Constants
    const Color slatePrimary = Color(0xFF3B5866);
    const Color deepCharcoal = Color(0xFF0F172A);
    const Color slateText = Color(0xFF64748B);
    const Color premiumBg = Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: premiumBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                
                // 🔬 Hero Visual Matrix
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: slatePrimary.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: slatePrimary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Icon(
                      Icons.science_rounded,
                      size: 72,
                      color: slatePrimary,
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),

                // Headline Copy Block
                const Text(
                  "Explore the Invisible",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: deepCharcoal,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Narrative Subtext
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    "Dive deep into the world of microbiology. Master specimen identification, stain mechanics, and cellular structures with an interactive virtual lens.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: slateText,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),
                
                const SizedBox(height: 60),

                // 🚀 Primary Action: New User Pipeline
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: slatePrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.signup);
                    },
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),

                // 🔑 Secondary Action: Return User Pipeline
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.login);
                    },
                    child: const Text(
                      "I already have an account",
                      style: TextStyle(
                        color: deepCharcoal,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart'; // Adjust this import path if necessary

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Holds the splash screen for 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    
    // 🛫 Seamlessly drops the user onto the Welcome Screen stack
    // Note: Verify if your route constant is named 'welcome', 'welcomePage', etc.
    Navigator.pushReplacementNamed(context, AppRoutes.welcome); 
  }

  @override
  Widget build(BuildContext context) {
    // Architectural Theme Constants matching Onboarding flows
    const Color slatePrimary = Color(0xFF3B5866);
    const Color deepCharcoal = Color(0xFF0F172A);
    const Color premiumBg = Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: premiumBg,
      body: SafeArea(
        child: Stack(
          children: [
            // Center Branding Matrix
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Studio Glow Backdrop with Native Icon Fallback
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              slatePrimary.withValues(alpha: 0.15),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      // 🔬 Clean, scalable vector representation of the app's core identity
                      const Icon(
                        Icons.biotech_rounded,
                        size: 130,
                        color: slatePrimary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Virtual Microscope",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: deepCharcoal,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            
            // Minimalist Editorial Loading Accent
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(slatePrimary.withValues(alpha: 0.4)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color slatePrimary = Color(0xFF3B5866);
    const Color deepCharcoal = Color(0xFF0F172A);
    const Color slateText = Color(0xFF64748B); // Premium replacement for non-existent Colors.slate

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 10),
              
              // App Branding Segment
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: slatePrimary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.biotech_rounded,
                      size: 48,
                      color: slatePrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Virtual Microscope",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: deepCharcoal,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Step into the interactive world of microscopy.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: slateText),
                  ),
                ],
              ),

              // App Features Checklist
              Column(
                children: [
                  _buildFeatureRow(
                    Icons.layers_outlined,
                    "High-Res Specimens",
                    "Examine complex biological cell formations with high fidelity zoom mechanics.",
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureRow(
                    Icons.wb_iridescent_rounded,
                    "Interactive Hotspots",
                    "Uncover core cellular structural data via integrated pin markers.",
                  ),
                ],
              ),

              // Navigation Controls
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: slatePrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Get Started",
                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Re-introduced the missing layout method with balanced braces
  Widget _buildFeatureRow(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Icon(icon, color: const Color(0xFF3B5866), size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 14, height: 1.3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
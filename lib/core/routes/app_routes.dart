import 'package:flutter/material.dart';

// Core Feature Imports
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/onboarding/screens/welcome_screen.dart';
import '../../features/authentication/screens/login_screen.dart';
import '../../features/authentication/screens/signup_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/slide_library/screens/library_screen.dart';

class AppRoutes {
  // Route Path Constants
  static const String splash = "/";
  static const String welcome = "/welcome";
  static const String login = "/login";
  static const String signup = "/signup";

  static const String home = "/home";
  static const String profile = "/profile";
  static const String progress = "/progress";
  static const String library = "/library";

  static const String hotspotInfo = "/hotspot-info";

  static const String adminDashboard = "/admin-dashboard";
  static const String slideManagement = "/slide-management";

  // Application Routing Table Matrix
  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    welcome: (context) => const WelcomePage(),
    login: (context) => const LoginPage(),
    signup: (context) => const SignupPage(),
    home: (context) => const HomeScreen(),
    library: (context) => const LibraryScreen(),

    //Smart Placeholders for remaining features under construction
    profile: (context) => _placeholderScreen("Profile Screen"),
    progress: (context) => _placeholderScreen("Progress Screen"),
    hotspotInfo: (context) => _placeholderScreen("Hotspot Info Screen"),
    adminDashboard: (context) => _placeholderScreen("Admin Dashboard"),
    slideManagement: (context) => _placeholderScreen("Slide Management"),
  };

  // Quick helper to display an elegant 'Under Construction' layout
  static Widget _placeholderScreen(String title) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          title, 
          style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
      ),
      body: Center(
        child: Text(
          "$title Coming Soon",
          style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
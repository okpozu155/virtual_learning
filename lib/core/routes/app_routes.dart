import 'package:flutter/material.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/onboarding/screens/welcome_screen.dart';
import '../../features/authentication/screens/login_screen.dart';
import '../../features/authentication/screens/signup_screen.dart';

import '../../features/home/screens/home_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/progress/screens/progress_screen.dart';
import '../../features/slide_library/screens/library_screen.dart';
import '../../features/authentication/screens/authentication_guard_screen.dart';
import '../../features/ai_tutor/screens/ai_tutor_screen.dart';
import '../../features/hotspot_notes/screens/hotspot_info_screen.dart';
import '../../features/notes/screens/notes_screen.dart';

import '../../features/admin/screens/slide_management_screen.dart';

// ONLY import these if the files actually exist
// import '../../features/admin/screens/quiz_management_screen.dart';
// import '../../features/admin/screens/analytics_screen.dart';

class AppRoutes {
  static const String splash = "/";
  static const String welcome = "/welcome";
  static const String login = "/login";
  static const String signup = "/signup";

  static const String home = "/home";
  static const String profile = "/profile";
  static const String progress = "/progress";
  static const String library = "/library";
  static const String askAi = "/AI_Tutor";
  static const String notes = "/notes";
  static const String hotspotInfo = "/hotspot-info";

  static const String adminDashboard = "/admin-dashboard";
  static const String slideManagement = "/slide-management";

  // Add these ONLY if screens exist
  // static const String quizManagement = "/quiz-management";
  // static const String analytics = "/analytics";

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),

    welcome: (context) => const WelcomePage(),

    login: (context) => const LoginPage(),

    signup: (context) => const SignupPage(),

    home: (context) => const HomeScreen(),

    profile: (context) => ProfileScreen(),

    progress: (context) => ProgressScreen(),

    library: (context) => const LibraryScreen(),

    notes: (context) => const NotesScreen(),

    hotspotInfo: (context) => const HotspotInfoScreen(),

    adminDashboard: (context) => const AdminGuard(),

    slideManagement: (context) => const SlideManagementScreen(),

    askAi: (context) => const ComingSoonPages(),

    // Uncomment only if screens exist

    // quizManagement: (context) =>
    //     const QuizManagementScreen(),

    // analytics: (context) =>
    //     const AnalyticsScreen(),
  };
}

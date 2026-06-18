import 'package:flutter/material.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/onboarding/screens/welcome_screen.dart';
import '../../features/authentication/screens/signup_screen.dart';
import '../../features/authentication/screens/login_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/progress/screens/progress_screen.dart';
import '../../features/slide_library/screens/library_screen.dart';
import '../../features/hotspot_notes/screens/hotspot_info_screen.dart';
//import '.../.../features/microscope/screens/microscope_screen.dart;






class AppRoutes {
  static const splash = "/";
  static const welcome = "/welcome";
  static const login = "/login";
  static const signup = "/signup";
  static const String home = '/home';
  static const String profile = '/profile';
  static const String progress = '/progress';
  static const String library = '/library';
  static const String hotspotInfo = '/hotspot-info';
  //static const string microscope = '/microscope'

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    welcome: (context) => const WelcomePage(),
    login: (context) => const LoginPage(),
    signup: (context) => const SignupPage(),
    home: (context) => const HomeScreen(),
    profile: (context) => ProfileScreen(),
    progress: (context) => ProgressScreen(),
    library: (context) => const LibraryScreen(),
    hotspotInfo: (context) => const HotspotInfoScreen(),
    //microscope: (context) => const MicroscopeScreen(),

  };
}


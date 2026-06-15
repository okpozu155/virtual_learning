import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; //ADDED: Core Firebase connector plugin

import 'features/authentication/screens/login_screen.dart';
import 'features/authentication/screens/signup_screen.dart';

void main() async {
  // ADDED: Ensures engine background channels are fully setup before calling platform channels
  WidgetsFlutterBinding.ensureInitialized();
  
  // ADDED: Safely boots up the Firebase linkage using your google-services.json file details
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Virtual Microscope',

      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

<<<<<<< HEAD
import 'features/authentication/screens/login_screen.dart';
import 'features/authentication/screens/signup_screen.dart';

void main() {
  runApp(const MyApp());
}
=======
import 'app.dart';
import 'firebase_options.dart';
>>>>>>> okpozu_branch

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

<<<<<<< HEAD
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
=======
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const VirtualMicroscopeApp(),
  );
>>>>>>> okpozu_branch
}
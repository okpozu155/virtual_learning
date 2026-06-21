import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Brought back for the database connection
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

void main() async { // Made async to handle the startup sequence
  // Ensure Flutter engine bindings are correct before launching logic
  WidgetsFlutterBinding.ensureInitialized();
  
  //The crucial handshake that prevents the [core/noapp] crash
  await Firebase.initializeApp();
  
  runApp(const VirtualLearnApp());
}

class VirtualLearnApp extends StatefulWidget {
  const VirtualLearnApp({super.key});

  @override
  State<VirtualLearnApp> createState() => _VirtualLearnAppState();
}

class _VirtualLearnAppState extends State<VirtualLearnApp> {
  // Logic is instantiated once at app boot
  late final AppThemeNotifier _themeNotifier;

  @override
  void initState() {
    super.initState();
    _themeNotifier = AppThemeNotifier();
    
    // Rebuild listener for app-wide theme synchronization
    _themeNotifier.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _themeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Injecting the Theme Scope Wrapper
    return AppThemeScope(
      notifier: _themeNotifier,
      child: MaterialApp(
        title: 'Virtual Learn',
        debugShowCheckedModeBanner: false,
        
        // Connecting MaterialApp to the current theme state
        themeMode: _themeNotifier.currentThemeMode,
        
        // Premium Light Theme Specs
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          colorSchemeSeed: const Color(0xFF3B5866),
          brightness: Brightness.light,
        ),
        
        // Modernized Dark Theme Specs
        darkTheme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFF0F172A),
          colorSchemeSeed: const Color(0xFF3B5866),
          brightness: Brightness.dark,
          cardTheme: const CardThemeData(color: Color(0xFF1E293B), elevation: 0),
        ),
        
        // Standardizing routes initialization
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}
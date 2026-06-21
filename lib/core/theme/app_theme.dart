import 'package:flutter/material.dart';

// 🧠 Part 1: The Change Notifier - Logic & State
class AppThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false; // Initial State (Light Mode)

  bool get isDarkMode => _isDarkMode;

  // Modern getter for MaterialApp.themeMode mapping
  ThemeMode get currentThemeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    // 📢 Critical: Rebuilds anyone looking at this state
    notifyListeners();
  }
}

// 🎛️ Part 2: The Inherited Widget - The invisible pipeline wrapper
class AppThemeScope extends InheritedWidget {
  final AppThemeNotifier notifier;

  const AppThemeScope({
    super.key,
    required this.notifier,
    required super.child,
  });

  // Helper method for other screens to easily find this scope
  static AppThemeNotifier of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppThemeScope>()!.notifier;
  }

  @override
  bool updateShouldNotify(covariant AppThemeScope oldWidget) {
    // Only notify dependents if the notifier instance somehow changes
    return oldWidget.notifier != notifier;
  }
}
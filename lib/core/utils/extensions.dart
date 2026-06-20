import 'package:flutter/material.dart';

extension StringExtension on String {
  bool get isEmail {
    return RegExp(
      r'^[\w\-\.]+@([\w\-]+\.)+[\w]{2,4}$',
    ).hasMatch(this);
  }

  String get capitalize {
    if (isEmpty) return this;

    return this[0].toUpperCase() +
        substring(1).toLowerCase();
  }
}

extension ContextExtension on BuildContext {
  Size get screenSize =>
      MediaQuery.of(this).size;

  double get screenWidth =>
      MediaQuery.of(this).size.width;

  double get screenHeight =>
      MediaQuery.of(this).size.height;

  ThemeData get theme =>
      Theme.of(this);

  TextTheme get textTheme =>
      Theme.of(this).textTheme;

  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

extension DateTimeExtension on DateTime {
  String get formattedDate {
    return '$day/$month/$year';
  }
}

extension DoubleExtension on double {
  String get percentage {
    return '${toStringAsFixed(0)}%';
  }
}
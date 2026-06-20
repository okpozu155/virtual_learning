import 'package:flutter/material.dart';

class Helpers {
  static void showSnackBar(
      BuildContext context,
      String message,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  static Future<void> showLoadingDialog(
      BuildContext context,
      ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static void closeDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  static String capitalize(String text) {
    if (text.isEmpty) return text;

    return text[0].toUpperCase() +
        text.substring(1).toLowerCase();
  }

  static String getInitials(String name) {
    List<String> parts = name.split(' ');

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return '${parts[0][0]}${parts[1][0]}'
        .toUpperCase();
  }

  static String formatPercentage(
      double value,
      ) {
    return '${value.toStringAsFixed(0)}%';
  }

  static String formatDuration(
      Duration duration,
      ) {
    String minutes =
    duration.inMinutes.remainder(60).toString();

    String seconds =
    duration.inSeconds.remainder(60).toString();

    return '$minutes:${seconds.padLeft(2, '0')}';
  }

  static Offset calculateHotspotPosition({
    required double imageWidth,
    required double imageHeight,
    required double xPercent,
    required double yPercent,
  }) {
    return Offset(
      imageWidth * xPercent,
      imageHeight * yPercent,
    );
  }
}
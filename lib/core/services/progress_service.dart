import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const String _progressKey = "slide_progress";

  static Future<void> saveProgress(
      String slideId,
      int percentage,
      ) async {
    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setInt(
      "${_progressKey}_$slideId",
      percentage,
    );
  }

  static Future<int> getProgress(
      String slideId,
      ) async {
    final prefs =
    await SharedPreferences.getInstance();

    return prefs.getInt(
      "${_progressKey}_$slideId",
    ) ??
        0;
  }

  static Future<double> getOverallProgress(
      List<String> slideIds,
      ) async {
    if (slideIds.isEmpty) return 0;

    int total = 0;

    for (final id in slideIds) {
      final progress =
      await getProgress(id);

      debugPrint("$id => $progress");

      total += progress;
    }

    final result =
        total / (slideIds.length * 100);

    debugPrint(
      "Overall result = $result",
    );

    return result;
  }

  static Future<void> resetProgress() async {
    final prefs =
    await SharedPreferences.getInstance();

    final keys = prefs.getKeys();

    for (final key in keys) {
      if (key.startsWith(_progressKey)) {
        await prefs.remove(key);
      }
    }
  }
}
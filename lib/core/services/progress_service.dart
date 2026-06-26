import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ProgressService {
  static const String _progressKey = "slide_progress";

  static String _uid() {
    return FirebaseAuth.instance.currentUser?.uid ?? "guest";
  }

  static String _userPrefix() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return "guest";
    }

    return user.uid;
  }

  static Future<void> saveProgress(
      String slideId,
      int percentage,
      ) async {
    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setInt(
      "${_progressKey}_${_uid()}_$slideId",
      percentage,
    );
  }

  static Future<int> getProgress(
      String slideId,
      ) async {
    final prefs =
    await SharedPreferences.getInstance();

    return prefs.getInt(
      "${_progressKey}_${_uid()}_$slideId",
    ) ??
        0;
  }

  static Future<double> getOverallProgress(
      List<String> slideIds,
      ) async {
    if (slideIds.isEmpty) {
      return 0;
    }

    int total = 0;

    for (final id in slideIds) {
      total += await getProgress(id);
    }

    return total / (slideIds.length * 100);
  }

  static Future<void> resetProgress() async {
    final prefs =
    await SharedPreferences.getInstance();

    final uid = _uid();

    for (final key in prefs.getKeys()) {
      if (key.startsWith(
          "${_progressKey}_${uid}_")) {
        await prefs.remove(key);
      }
    }
  }
}
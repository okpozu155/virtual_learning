import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const String _progressKey = "slide_progress";
  static const String _viewedSlidesKey = "viewed_slides";

  static String _uid() {
    return FirebaseAuth.instance.currentUser?.uid ?? "guest";
  }

  static Future<void> saveProgress(String slideId, int percentage) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt("${_progressKey}_${_uid()}_$slideId", percentage);

    await _syncProgressDocument();
  }

  static Future<void> markSlideViewed(String slideId) async {
    final prefs = await SharedPreferences.getInstance();

    final key = "${_viewedSlidesKey}_${_uid()}";

    final viewedSlides = prefs.getStringList(key) ?? [];

    if (!viewedSlides.contains(slideId)) {
      viewedSlides.add(slideId);

      await prefs.setStringList(key, viewedSlides);
    }

    await _syncProgressDocument();
  }

  static Future<int> getProgress(String slideId) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt("${_progressKey}_${_uid()}_$slideId") ?? 0;
  }

  static Future<double> getOverallProgress(List<String> slideIds) async {
    if (slideIds.isEmpty) {
      return 0;
    }

    int total = 0;

    for (final id in slideIds) {
      total += await getProgress(id);
    }

    return (total / (slideIds.length * 100)) * 100;
  }

  static Future<void> _syncProgressDocument() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    final uid = user.uid;
    final scorePrefix = "${_progressKey}_${uid}_";
    final viewedSlides =
        prefs.getStringList("${_viewedSlidesKey}_${uid}") ?? [];

    final scores = <int>[];

    for (final key in prefs.getKeys()) {
      if (key.startsWith(scorePrefix)) {
        scores.add(prefs.getInt(key) ?? 0);
      }
    }

    final averageScore = scores.isEmpty
        ? 0.0
        : scores.reduce((a, b) => a + b) / scores.length;

    await FirebaseFirestore.instance.collection('progress').doc(uid).set({
      'slidesViewed': viewedSlides.length,
      'quizzesTaken': scores.length,
      'averageScore': averageScore,
      'streakDays': scores.isEmpty && viewedSlides.isEmpty ? 0 : 1,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();

    final uid = _uid();

    for (final key in prefs.getKeys()) {
      if (key.startsWith("${_progressKey}_${uid}_")) {
        await prefs.remove(key);
      }
    }

    await prefs.remove("${_viewedSlidesKey}_${uid}");

    await _syncProgressDocument();
  }
}

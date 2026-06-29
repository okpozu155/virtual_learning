import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  String get _uid =>
      FirebaseAuth.instance.currentUser?.uid ?? 'guest';

  String get _lastViewedKey =>
      'last_viewed_slide_$_uid';

  String get _recentSlidesKey =>
      'recent_slides_$_uid';

  Future<void> saveLastViewedSlide(
      String slideId,
      ) async {
    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      _lastViewedKey,
      slideId,
    );

    List<String> recentSlides =
        prefs.getStringList(
          _recentSlidesKey,
        ) ??
            [];

    recentSlides.remove(slideId);

    recentSlides.insert(0, slideId);

    if (recentSlides.length > 7) {
      recentSlides =
          recentSlides.sublist(0, 7);
    }

    await prefs.setStringList(
      _recentSlidesKey,
      recentSlides,
    );
  }

  Future<String?> getLastViewedSlide() async {
    final prefs =
    await SharedPreferences.getInstance();

    return prefs.getString(
      _lastViewedKey,
    );
  }

  Future<List<String>> getRecentSlides() async {
    final prefs =
    await SharedPreferences.getInstance();

    return prefs.getStringList(
      _recentSlidesKey,
    ) ??
        [];
  }

  Future<void> clearUserHistory() async {
    final prefs =
    await SharedPreferences.getInstance();

    await prefs.remove(_lastViewedKey);
    await prefs.remove(_recentSlidesKey);
  }
}
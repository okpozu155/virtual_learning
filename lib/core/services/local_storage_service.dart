import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String lastViewedSlideKey =
      'last_viewed_slide';

  static const String recentSlidesKey =
      'recent_slides';

  Future<void> saveLastViewedSlide(
      String slideId,
      ) async {
    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      lastViewedSlideKey,
      slideId,
    );

    List<String> recentSlides =
        prefs.getStringList(
          recentSlidesKey,
        ) ??
            [];

    recentSlides.remove(slideId);

    recentSlides.insert(0, slideId);

    if (recentSlides.length > 7) {
      recentSlides = recentSlides.sublist(0, 7);
    }

    await prefs.setStringList(
      recentSlidesKey,
      recentSlides,
    );
  }

  Future<String?> getLastViewedSlide() async {
    final prefs =
    await SharedPreferences.getInstance();

    return prefs.getString(
      lastViewedSlideKey,
    );
  }

  Future<List<String>> getRecentSlides() async {
    final prefs =
    await SharedPreferences.getInstance();

    return prefs.getStringList(
      recentSlidesKey,
    ) ??
        [];
  }
}
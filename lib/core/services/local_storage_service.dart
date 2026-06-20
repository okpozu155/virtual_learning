import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String lastViewedSlideKey =
      'last_viewed_slide';

  Future<void> saveLastViewedSlide(
      String slideId,
      ) async {
    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      lastViewedSlideKey,
      slideId,
    );
  }

  Future<String?> getLastViewedSlide() async {
    final prefs =
    await SharedPreferences.getInstance();

    return prefs.getString(
      lastViewedSlideKey,
    );
  }
}
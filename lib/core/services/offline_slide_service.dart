import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineSlideService {
  static const String downloadedSlidesKey =
      'downloaded_slides';

  Future<String> downloadSlide(
      String slideId,
      String imageUrl,
      ) async {
    final response =
    await http.get(Uri.parse(imageUrl));

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to download slide',
      );
    }

    final directory =
    await getApplicationDocumentsDirectory();

    final file = File(
      '${directory.path}/$slideId.jpg',
    );

    await file.writeAsBytes(
      response.bodyBytes,
    );

    await _saveSlidePath(
      slideId,
      file.path,
    );

    return file.path;
  }

  Future<void> _saveSlidePath(
      String slideId,
      String path,
      ) async {
    final prefs =
    await SharedPreferences.getInstance();

    final data =
    prefs.getString(downloadedSlidesKey);

    Map<String, dynamic> slides = {};

    if (data != null) {
      slides =
      jsonDecode(data)
      as Map<String, dynamic>;
    }

    slides[slideId] = path;

    await prefs.setString(
      downloadedSlidesKey,
      jsonEncode(slides),
    );
  }

  Future<String?> getOfflinePath(
      String slideId,
      ) async {
    final prefs =
    await SharedPreferences.getInstance();

    final data =
    prefs.getString(downloadedSlidesKey);

    if (data == null) {
      return null;
    }

    final slides =
    jsonDecode(data)
    as Map<String, dynamic>;

    return slides[slideId];
  }

  Future<bool> isDownloaded(
      String slideId,
      ) async {
    final path =
    await getOfflinePath(slideId);

    if (path == null) {
      return false;
    }

    return File(path).exists();
  }

  Future<void> deleteSlide(
      String slideId,
      ) async {
    final prefs =
    await SharedPreferences.getInstance();

    final data =
    prefs.getString(downloadedSlidesKey);

    if (data == null) return;

    final slides =
    jsonDecode(data)
    as Map<String, dynamic>;

    final path = slides[slideId];

    if (path != null) {
      final file = File(path);

      if (await file.exists()) {
        await file.delete();
      }
    }

    slides.remove(slideId);

    await prefs.setString(
      downloadedSlidesKey,
      jsonEncode(slides),
    );
  }

  Future<List<String>> getDownloadedSlides()
  async {
    final prefs =
    await SharedPreferences.getInstance();

    final data =
    prefs.getString(downloadedSlidesKey);

    if (data == null) {
      return [];
    }

    final slides =
    jsonDecode(data)
    as Map<String, dynamic>;

    return slides.keys.toList();
  }
}
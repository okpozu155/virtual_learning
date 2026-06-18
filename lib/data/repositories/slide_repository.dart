import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/slide_model.dart';

class SlideRepository {
  Future<List<SlideModel>> getSlides() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/slides.json',
    );

    final List<dynamic> data =
    json.decode(jsonString);

    return data
        .map(
          (e) => SlideModel.fromJson(e),
    )
        .toList();
  }

  Future<SlideModel?> getSlideById(
      String id,
      ) async {
    final slides = await getSlides();

    try {
      return slides.firstWhere(
            (slide) => slide.id == id,
      );
    } catch (_) {
      return null;
    }
  }
}
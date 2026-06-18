import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/hotspot_model.dart';

class HotspotRepository {
  Future<List<HotspotModel>> getHotspots(
      String slideId,
      ) async {
    final jsonString = await rootBundle.loadString(
      'assets/data/hotspots.json',
    );

    final List data = json.decode(jsonString);

    final slideData = data.firstWhere(
          (item) => item['slideId'] == slideId,
      orElse: () => null,
    );

    if (slideData == null) {
      return [];
    }

    return (slideData['hotspots'] as List)
        .map(
          (e) => HotspotModel.fromJson(e),
    )
        .toList();
  }
}
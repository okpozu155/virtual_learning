import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/annotations_model.dart'; 

class AnnotationRepository {
  Future<List<AnnotationModel>> getAnnotations(String slideId) async {
    final jsonString = await rootBundle.loadString('assets/data/annotations.json');
    final List<dynamic> data = json.decode(jsonString);

    final slideData = data.firstWhere(
      (e) => e['slideId'] == slideId,
      orElse: () => null,
    );

    if (slideData == null) {
      return [];
    }

    return (slideData['annotations'] as List)
        .map((e) => AnnotationModel.fromJson(e))
        .toList();
  }
}

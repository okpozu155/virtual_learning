import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../models/annotations_model.dart'; 

class AnnotationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AnnotationModel>> getAnnotations(String slideId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('annotations').doc(slideId).get();

      if (!doc.exists || doc.data() == null) {
        return [];
      }

      final data = doc.data() as Map<String, dynamic>;

      if (data['annotations'] == null) {
        return [];
      }
      return (data['annotations'] as List)
      .map((e) => AnnotationModel.fromJson(e))
      .toList();
    } catch (e) {
      print('Error fetching annotations from Firestore: $e');
      return [];
    }
  }
}
/*   Future<List<AnnotationModel>> getAnnotations(String slideId) async {
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
  } */

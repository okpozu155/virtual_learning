import 'package:cloud_firestore/cloud_firestore.dart';

class AnnotationRepository {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;
  

  Future<void> savePolygonAnnotation({
    required String slideId,
    required String title,
    required String description,
    required String notes,
    required String color,
    required List<Map<String, double>> points,
  }) async {
    await FirebaseFirestore.instance
        .collection('slides')
        .doc(slideId)
        .collection('annotations')
        .add({
      'type': 'polygon',
      'title': title,
      'description': description,
      'notes': notes,
      'color': color,
      'points': points,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Map<String, dynamic>>> getAnnotations(
      String slideId) async {
    final snapshot = await _firestore
        .collection('annotations')
        .where('slideId', isEqualTo: slideId)
        .get();

    return snapshot.docs
        .map((doc) => {
      'id': doc.id,
      ...doc.data(),
    })
        .toList();
  }

  Future<void> deleteAnnotation(
      String annotationId) async {
    await _firestore
        .collection('annotations')
        .doc(annotationId)
        .delete();
  }
}
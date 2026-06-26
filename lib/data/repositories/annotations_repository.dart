import 'package:cloud_firestore/cloud_firestore.dart';

class AnnotationRepository {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  /// ==========================
  /// CREATE POINT ANNOTATION
  /// ==========================
  Future<void> saveAnnotation({
    required String slideId,
    required String title,
    required String description,
    required String notes,
    required String color,
    required double x,
    required double y,
  }) async {
    await _firestore
        .collection('slides')
        .doc(slideId)
        .collection('annotations')
        .add({
      'type': 'point',
      'title': title,
      'description': description,
      'notes': notes,
      'color': color,
      'x': x,
      'y': y,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// ==========================
  /// CREATE POLYGON ANNOTATION
  /// ==========================
  Future<void> savePolygonAnnotation({
    required String slideId,
    required String title,
    required String description,
    required String notes,
    required String color,
    required List<Map<String, double>> points,
  }) async {
    await _firestore
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
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// ==========================
  /// LOAD ANNOTATIONS
  /// ==========================
  Future<List<Map<String, dynamic>>> getAnnotations(
      String slideId,
      ) async {
    final snapshot = await _firestore
        .collection('slides')
        .doc(slideId)
        .collection('annotations')
        .orderBy('createdAt')
        .get();

    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data(),
      };
    }).toList();
  }

  /// ==========================
  /// UPDATE ANNOTATION
  /// Works for both point and polygon
  /// ==========================
  Future<void> updateAnnotation({
    required String slideId,
    required String annotationId,
    required String title,
    required String description,
    required String notes,
    required String color,
  }) async {
    await _firestore
        .collection('slides')
        .doc(slideId)
        .collection('annotations')
        .doc(annotationId)
        .update({
      'title': title,
      'description': description,
      'notes': notes,
      'color': color,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// ==========================
  /// UPDATE POLYGON POINTS
  /// ==========================
  Future<void> updatePolygonPoints({
    required String slideId,
    required String annotationId,
    required List<Map<String, double>> points,
  }) async {
    await _firestore
        .collection('slides')
        .doc(slideId)
        .collection('annotations')
        .doc(annotationId)
        .update({
      'points': points,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// ==========================
  /// DELETE ANNOTATION
  /// ==========================
  Future<void> deleteAnnotation({
    required String slideId,
    required String annotationId,
  }) async {
    await _firestore
        .collection('slides')
        .doc(slideId)
        .collection('annotations')
        .doc(annotationId)
        .delete();
  }

  /// ==========================
  /// GET SINGLE ANNOTATION
  /// ==========================
  Future<Map<String, dynamic>?> getAnnotation({
    required String slideId,
    required String annotationId,
  }) async {
    final doc = await _firestore
        .collection('slides')
        .doc(slideId)
        .collection('annotations')
        .doc(annotationId)
        .get();

    if (!doc.exists) {
      return null;
    }

    return {
      'id': doc.id,
      ...doc.data()!,
    };
  }
}
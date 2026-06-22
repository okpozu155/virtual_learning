import 'package:cloud_firestore/cloud_firestore.dart';

class AnnotationRepository {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> saveAnnotation({
    required String slideId,
    required String title,
    required String description,
    required String notes,
    required double x,
    required double y,
    String color = "#FF0000",
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
      'x': x,
      'y': y,
      'color': color,
      'createdAt':
      FieldValue.serverTimestamp(),
    });
  }

  Future<void> savePolygonAnnotation({
    required String slideId,
    required String title,
    required String description,
    required String notes,
    required String color,
    required List<Map<String, dynamic>>
    points,
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
      'createdAt':
      FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateAnnotation({
    required String slideId,
    required String annotationId,
    required String title,
    required String description,
    required String notes,
    String? color,
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
      if (color != null)
        'color': color,
    });
  }

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

  Stream<List<Map<String, dynamic>>>
  streamAnnotations(
      String slideId,
      ) {
    return _firestore
        .collection('slides')
        .doc(slideId)
        .collection('annotations')
        .orderBy('createdAt')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => {
          'id': doc.id,
          ...doc.data(),
        },
      )
          .toList(),
    );
  }

  Future<List<Map<String, dynamic>>>
  getAnnotations(
      String slideId,
      ) async {
    final snapshot =
    await _firestore
        .collection('slides')
        .doc(slideId)
        .collection('annotations')
        .get();

    return snapshot.docs
        .map(
          (doc) => {
        'id': doc.id,
        ...doc.data(),
      },
    )
        .toList();
  }
}
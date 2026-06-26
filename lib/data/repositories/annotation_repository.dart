import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../features/annotation/models/annotation_shape.dart';

class AnnotationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Collection:
  ///
  /// slides
  ///   └── slideId
  ///         └── annotations
  ///                └── annotationId
  CollectionReference<Map<String, dynamic>> _collection(
      String slideId,
      ) {
    return _firestore
        .collection("slides")
        .doc(slideId)
        .collection("annotations");
  }

  //==========================================================
  // LOAD ONCE
  //==========================================================

  Future<List<AnnotationShape>> loadShapes(String slideId) async {
    final snapshot = await _collection(slideId).get();

    for (final doc in snapshot.docs) {
      print("----------------------");
      print(doc.data());
      print("----------------------");
    }

    return snapshot.docs
        .map((doc) => AnnotationShape.fromFirestore(doc.id, doc.data()))
        .toList();
  }

  //==========================================================
  // REALTIME
  //==========================================================

  Stream<List<AnnotationShape>> streamShapes(
      String slideId,
      ) {
    return _collection(slideId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) =>
            AnnotationShape.fromFirestore(
              doc.id,
              doc.data(),
            ),
      )
          .toList(),
    );
  }

  //==========================================================
  // CREATE
  //==========================================================

  Future<void> createShape({
    required String slideId,
    required AnnotationShape shape,
  }) async {
    try {
      await _collection(slideId)
          .doc(shape.id)
          .set(shape.toFirestore());

      print("Annotation saved.");
    } catch (e, stack) {
      print("Firestore save failed:");
      print(e);
      print(stack);
    }
  }
  //==========================================================
  // UPDATE
  //==========================================================

  Future<void> updateShape({
    required String slideId,
    required AnnotationShape shape,
  }) async {
    await _collection(slideId)
        .doc(shape.id)
        .update(shape.toFirestore());
  }

  //==========================================================
  // DELETE
  //==========================================================

  Future<void> deleteShape({
    required String slideId,
    required String annotationId,
  }) async {
    await _collection(slideId)
        .doc(annotationId)
        .delete();
  }

  //==========================================================
  // DELETE ALL
  //==========================================================

  Future<void> deleteAllShapes(
      String slideId,
      ) async {
    final snapshot =
    await _collection(slideId).get();

    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  //==========================================================
  // SAVE MANY
  //==========================================================

  Future<void> saveShapes({
    required String slideId,
    required List<AnnotationShape> shapes,
  }) async {
    final batch = _firestore.batch();

    for (final shape in shapes) {
      final ref = _collection(slideId).doc(shape.id);

      batch.set(
        ref,
        shape.toFirestore(),
      );
    }

    await batch.commit();
  }

  //==========================================================
  // LEGACY SUPPORT
  //==========================================================

  Future<List<Map<String, dynamic>>> getAnnotations(
      String slideId,
      ) async {
    final snapshot =
    await _collection(slideId).get();

    return snapshot.docs
        .map((e) => e.data())
        .toList();
  }

  Stream<List<Map<String, dynamic>>> streamAnnotations(
      String slideId,
      ) {
    return _collection(slideId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((e) => e.data())
          .toList(),
    );
  }
}
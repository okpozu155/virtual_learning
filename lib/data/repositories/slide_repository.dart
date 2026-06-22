import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/slide_model.dart';

class SlideRepository {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  Future<void> deleteSlide(String slideId) async {
    await FirebaseFirestore.instance
        .collection('slides')
        .doc(slideId)
        .delete();
  }

  Future<List<SlideModel>> getSlides() async {
    final snapshot =
    await firestore
        .collection('slides')
        .get();

    return snapshot.docs.map((doc) {
      return SlideModel.fromJson({
        'id': doc.id,
        ...doc.data(),
      });
    }).toList();
  }

  Future<SlideModel?> getSlideById(
      String slideId) async {
    final doc =
    await firestore
        .collection('slides')
        .doc(slideId)
        .get();

    if (!doc.exists) return null;

    return SlideModel.fromJson({
      'id': doc.id,
      ...doc.data()!,
    });
  }
}
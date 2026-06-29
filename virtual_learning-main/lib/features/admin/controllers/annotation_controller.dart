import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../firebase/firebase_collections.dart';


class AnnotationController {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  Future<void> createHotspot({
    required String slideId,
    required String title,
    required String description,
    required String notes,
    required double x,
    required double y,
  }) async {
    final doc = firestore
        .collection(FirestoreCollections.slides)
        .doc(slideId)
        .collection('hotspots')
        .doc();

    await doc.set({
      'id': doc.id,
      'title': title,
      'description': description,
      'notes': notes,
      'x': x,
      'y': y,
      'createdAt':
      FieldValue.serverTimestamp(),
    });
  }
}

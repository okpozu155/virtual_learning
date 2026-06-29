import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../firebase/firebase_collections.dart';


class AdminController {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  Future<void> deleteSlide(
      String slideId,
      ) async {
    await firestore
        .collection(FirestoreCollections.slides)
        .doc(slideId)
        .delete();
  }

  Future<void> deleteHotspot(
      String slideId,
      String hotspotId,
      ) async {
    await firestore
        .collection(FirestoreCollections.slides)
        .doc(slideId)
        .collection('hotspots')
        .doc(hotspotId)
        .delete();
  }
}
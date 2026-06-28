import 'package:cloud_firestore/cloud_firestore.dart';

import '../../firebase/firebase_collections.dart';
import '../models/hotspot_model.dart';

class HotspotRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<HotspotModel>> getHotspots(String slideId) async {
    final snapshot = await _firestore
        .collection(FirestoreCollections.hotspots(slideId))
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs
          .map((doc) => HotspotModel.fromJson({'id': doc.id, ...doc.data()}))
          .toList();
    }

    return [];
  }

  Stream<List<HotspotModel>> streamHotspots(String slideId) {
    return _firestore
        .collection(FirestoreCollections.hotspots(slideId))
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => HotspotModel.fromJson({'id': doc.id, ...doc.data()}),
              )
              .toList(),
        );
  }
}

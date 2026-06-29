import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/progress_model.dart';

class ProgressRepository {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<ProgressModel> getProgress(
      String userId,
      ) async {
    final doc = await _firestore
        .collection('progress')
        .doc(userId)
        .get();

    if (!doc.exists) {
      return ProgressModel(
        slidesViewed: 0,
        quizzesTaken: 0,
        averageScore: 0,
        streakDays: 0,
      );
    }

    return ProgressModel.fromJson(
      doc.data()!,
    );
  }

  Stream<ProgressModel> progressStream(
      String userId,
      ) {
    return _firestore
        .collection('progress')
        .doc(userId)
        .snapshots()
        .map(
          (snapshot) => ProgressModel.fromJson(
        snapshot.data() ?? {},
      ),
    );
  }

  Future<void> saveProgress({
    required String userId,
    required ProgressModel progress,
  }) async {
    await _firestore
        .collection('progress')
        .doc(userId)
        .set(
      progress.toJson(),
      SetOptions(merge: true),
    );
  }

  Future<void> createInitialProgress(
      String userId,
      ) async {
    await _firestore
        .collection('progress')
        .doc(userId)
        .set({
      'slidesViewed': 0,
      'quizzesTaken': 0,
      'averageScore': 0,
      'streakDays': 0,
    });
  }
}
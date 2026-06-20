import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  CollectionReference get slides =>
      firestore.collection('slides');

  CollectionReference get quizzes =>
      firestore.collection('quizzes');
}
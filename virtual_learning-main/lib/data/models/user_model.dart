import 'package:firebase_auth/firebase_auth.dart';

class MyUserModel {
  final String uid;
  final String email;
  final String displayName;
  final String role;
  final String photoUrl;
  final int age;

  MyUserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    this.photoUrl = '',
    this.age = 0,
  });

  factory MyUserModel.fromFirebase(
      User firebaseUser,
      Map<String, dynamic>? extraData,
      ) {
    return MyUserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? 'Anonymous',
      role: extraData?['role'] ?? 'student',
      photoUrl: extraData?['photoUrl'] ?? '',
      age: extraData?['age'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role,
      'photoUrl': photoUrl,
      'age': age,
    };
  }
}
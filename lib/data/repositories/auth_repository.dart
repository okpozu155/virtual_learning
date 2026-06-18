import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges =>
      _auth.authStateChanges();

  Future<UserCredential> login({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signup({
    required String email,
    required String password,
  }) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
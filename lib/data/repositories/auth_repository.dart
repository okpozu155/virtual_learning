import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  // Direct In-Memory Database Matrix for real-time testing without database latency
  static final Map<String, Map<String, String>> _userDatabase = {
    "micro@test.com": {"name": "Alex", "password": "password123"}
  };

  // 1. Fully-Functional Signup Pipeline
  Future<void> registerUser(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate remote network lag

    final cleanEmail = email.trim().toLowerCase();

    if (_userDatabase.containsKey(cleanEmail)) {
      throw Exception("An account with this email already exists.");
    }

    // Persist new credential values into live application state
    _userDatabase[cleanEmail] = {
      "name": name,
      "password": password,
    };
  }

  // 2. Fully-Functional Login Verification Flow
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final cleanEmail = email.trim().toLowerCase();

    if (!_userDatabase.containsKey(cleanEmail)) {
      throw Exception("No user found with this email. Please sign up.");
    }

    if (_userDatabase[cleanEmail]?["password"] != password) {
      throw Exception("Incorrect password. Please try again.");
    }
  }

  // 3. Modernized Google Account Authentication Engine (google_sign_in v7+)
  Future<String> signInWithGoogle() async {
    try {
      // Access the modern global thread-safe singleton manager
      final googleSignIn = GoogleSignIn.instance;

      // Explicit initialization is mandatory before hitting native OS modules
      await googleSignIn.initialize();

      // Fire modern Android Credential Manager / iOS Modal Sheet view layer
      final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();

      if (googleUser == null) {
        throw Exception("Sign in cancelled by user.");
      }

      // Return the verified string name directly back up to controllers
      return googleUser.displayName ?? "Google User";
    } catch (error) {
      // Keep background system exceptions legible
      throw Exception(error.toString());
    }
  }

  // 4. Reactive Credentials Retrieval Flow
  Future<String> recoverPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final cleanEmail = email.trim().toLowerCase();

    if (!_userDatabase.containsKey(cleanEmail)) {
      throw Exception("No account registered with this email address.");
    }

    return _userDatabase[cleanEmail]?["password"] ?? "password123";
  }
}
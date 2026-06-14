import 'dart:async';

class AuthRepository {
  // Our temporary database running in the app's memory
  static final Map<String, Map<String, String>> _userDatabase = {
    // Pre-seeding a test account so you can test login immediately if you want
    "micro@test.com": {"name": "Alex", "password": "password123"}
  };

  // 1. Functional Signup Logic
  Future<void> registerUser(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network lag

    final cleanEmail = email.trim().toLowerCase();

    if (_userDatabase.containsKey(cleanEmail)) {
      throw Exception("An account with this email already exists.");
    }

    // Save user details to memory
    _userDatabase[cleanEmail] = {
      "name": name,
      "password": password,
    };
  }

  // 2. Functional Login Logic
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

  // 3. Functional Google Auth Mock
  Future<String> signInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 1));
    // Real Google Auth requires setting up Firebase console developer keys.
    // This perfectly mocks a successful return payload.
    return "Microbiology Scholar";
  }
}
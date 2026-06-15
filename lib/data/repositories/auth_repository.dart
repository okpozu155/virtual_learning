import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  // Global reference pointer directly to your active Firebase project instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 1. Fully-Functional Real Firebase Signup Pipeline
  Future<void> registerUser(String name, String email, String password) async {
    try {
      final cleanEmail = email.trim().toLowerCase();
      
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "An error occurred during registration.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // 2. Fully-Functional Real Firebase Login Verification Flow
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      final cleanEmail = email.trim().toLowerCase();
      
      await _auth.signInWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "An error occurred during sign in.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // 3. Complete Google Account Ecosystem Authentication Engine
  Future<String> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize(
        serverClientId: "396894514828-tk1cgop21q20g85itih68tr4jgv1kafc.apps.googleusercontent.com",
      );

      // Trigger the physical device native account window prompt layer
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();
      
      // Grabbing the authentication details synchronously
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Passing only the idToken since Firebase handles identity verification safely without the accessToken
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      return userCredential.user?.displayName ?? "Google User";
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Google Sign-In validation failed on the backend.");
    } catch (error) {
      if (error.toString().contains("canceled") || error.toString().contains("cancelled")) {
        throw Exception("Sign in cancelled by user.");
      }
      throw Exception(error.toString());
    }
  }

  // 4. Real Firebase Password Reset Email Engine
  Future<void> recoverPassword(String email) async {
    try {
      final cleanEmail = email.trim().toLowerCase();
      
      // Instructs Firebase to route a localized secure dashboard link directly to the target mailbox
      await _auth.sendPasswordResetEmail(email: cleanEmail);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Failed to fire off password recovery email.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
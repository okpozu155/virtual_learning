import 'package:flutter/material.dart';
import '../../../data/repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Handles User Sign Up
  Future<bool> signUp(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRepository.registerUser(name, email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      notifyListeners();
      return false;
    }
  }

  // Handles User Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRepository.signInWithEmailAndPassword(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      notifyListeners();
      return false;
    }
  }

  // Handles Google Login
  Future<String?> loginWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      final displayName = await _authRepository.signInWithGoogle();
      _isLoading = false;
      notifyListeners();
      return displayName;
    } catch (_) {
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
}
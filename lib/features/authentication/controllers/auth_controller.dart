import 'package:flutter/material.dart';
import '../../../data/repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Global State Reset Configuration
  void _resetState() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }

  // Sign-Up Action Handler
  Future<bool> signUp(String name, String email, String password) async {
    _resetState();
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

  // Credentials Verification Handler
  Future<bool> login(String email, String password) async {
    _resetState();
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

  // Native Account Selection Overlay Hook
  Future<String?> loginWithGoogle() async {
    _resetState();
    try {
      final displayName = await _authRepository.signInWithGoogle();
      _isLoading = false;
      notifyListeners();
      return displayName;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      notifyListeners();
      return null;
    }
  }

  // Password Recovery Matrix Processor - 🎯 UPDATED TO RETURN BOOL
  Future<bool> forgotPassword(String email) async {
    _resetState();
    try {
      await _authRepository.recoverPassword(email);
      
      _isLoading = false;
      notifyListeners();
      
      return true; // 🎯 Success! Returns true to make 'if (success)' work flawlessly
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      notifyListeners();
      return false; // 🎯 Something broke, returns false
    }
  }
}
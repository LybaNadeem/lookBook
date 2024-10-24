import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import for User
import '../controllers/auth_controller.dart';

class AuthProvider with ChangeNotifier {
  final AuthController _controller = AuthController();
  User? _user;

  User? get user => _user;

  // Sign in method
  Future<void> signIn(String email, String password) async {
    try {
      _user = await _controller.signInWithEmail(email, password);
      notifyListeners();
    } catch (e) {
      // Handle sign in error (optional)
      print("Sign in error: $e");
      throw e; // Re-throw the error for further handling if needed
    }
  }

  // Sign up method
  Future<void> signUp(String email, String password) async {
    try {
      _user = await _controller.signUpWithEmail(email, password);
      notifyListeners();
    } catch (e) {
      // Handle sign up error (optional)
      print("Sign up error: $e");
      throw e; // Re-throw the error for further handling if needed
    }
  }

  // Sign out method
  Future<void> signOut() async {
    await _controller.signOut();
    _user = null;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingProvider with ChangeNotifier {
  final OnboardingController _controller = OnboardingController();
  bool _isFirstTimeUser = true;

  bool get isFirstTimeUser => _isFirstTimeUser;

  // Check if it's the first time the user is opening the app
  Future<void> checkFirstTimeUser() async {
    _isFirstTimeUser = !(await _controller.hasSeenOnboarding());
    notifyListeners();
  }

  // Complete the onboarding process
  Future<void> completeOnboarding() async {
    await _controller.setSeenOnboarding();
    _isFirstTimeUser = false;
    notifyListeners();
  }
}

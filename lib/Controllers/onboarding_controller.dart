import 'package:shared_preferences/shared_preferences.dart';

class OnboardingController {
  // Check if the onboarding has been seen
  Future<bool> hasSeenOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('seenOnboarding') ?? false;
  }

  // Set the onboarding as completed
  Future<void> setSeenOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
  }
}

import 'package:firebase_auth/firebase_auth.dart';

class ProfileCustomerController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get the current logged-in user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Update the display name of the user
  Future<void> updateDisplayName(String name) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      await user.reload(); // Reload the user data after updating
    }
  }

  /// Update the photo URL of the user
  Future<void> updatePhotoURL(String photoURL) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updatePhotoURL(photoURL);
      await user.reload(); // Reload the user data after updating
    }
  }

  /// Update the email of the user
  Future<void> updateEmail(String email) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updateEmail(email);
    }
  }

  /// Update the phone number (requires reauthentication with Firebase)
  Future<void> updatePhoneNumber(String phoneNumber) async {
    // Note: Firebase requires reauthentication for sensitive updates
    // Implement reauthentication flow here
    throw UnimplementedError("Phone number update is not yet implemented");
  }
}

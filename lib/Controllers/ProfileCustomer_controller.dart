import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfilecustomerController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  /// Get the current logged-in user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Fetch user profile data from Firestore
  Future<Map<String, dynamic>?> getUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
    }
    return null; // Return null if user is not logged in or document does not exist
  }

  /// Update user profile fields in Firestore
  Future<void> updateUserProfile({
    String? fullName,
    String? instagram,
    String? linkedin,
    String? phone,
  }) async {
    User? user = _auth.currentUser;
    if (user != null) {
      Map<String, dynamic> dataToUpdate = {};
      if (fullName != null) dataToUpdate['fullName'] = fullName;
      if (instagram != null) dataToUpdate['instagram'] = instagram;
      if (linkedin != null) dataToUpdate['linkedin'] = linkedin;
      if (phone != null) dataToUpdate['phone'] = phone;

      await _firestore.collection('users').doc(user.uid).update(dataToUpdate);
    }
  }

  /// Update the display name of the user in Firebase Auth
  Future<void> updateDisplayName(String name) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      await user.reload();
    }
  }

  /// Update the email of the user in Firebase Auth
  Future<void> updateEmail(String email) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updateEmail(email);
    }
  }
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await _uploadImageToFirebase(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }

  // Public method to call _pickImage
  Future<void> pickImageForProfile() async {
    await _pickImage();
  }

  // Function to upload image to Firebase Storage
  Future<String> _uploadImageToFirebase(String imagePath) async {
    File file = File(imagePath);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      // Upload the image to Firebase Storage
      Reference firebaseStorageRef =
      FirebaseStorage.instance.ref().child('profile_pictures/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      // Now update the Firestore user profile with the new image URL
      await updateProfilePicture(downloadURL);
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Error uploading image');
    }
  }

  // Function to update the profile picture in Firestore
  Future<void> updateProfilePicture(String imageURL) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'photoURL': imageURL,
      });
    }
  }

}

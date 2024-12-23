import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomepageController extends ChangeNotifier {
  bool isLoading = true;
  List<Map<String, dynamic>> userProducts = [];

  // Fetch products created by the current user
  Future<void> getUserProducts() async {
    isLoading = true;
    notifyListeners(); // Notify UI to show loading state

    try {
      // Get current user ID
      final String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        print("No user is currently logged in.");
        isLoading = false;
        notifyListeners();
        return;
      }

      print("Fetching products for user ID: $userId from Firestore...");

      // Query Firestore for products created by the current user
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('userId', isEqualTo: userId) // Filter by userId
          .get();

      // Clear existing products list
      userProducts.clear();

      // Populate the list with user products
      for (var doc in querySnapshot.docs) {
        userProducts.add({
          'productId': doc.id,
          'dressTitle': doc['DressTitle'] ?? '',
          'description': doc['projectDescription'] ?? '',
          'price': double.tryParse(doc['price'].toString()) ?? 0.0,
          'imageList': List<String>.from(doc['image'] ?? []),
        });
      }

      print("User's products fetched successfully.");
    } catch (e) {
      print('Error fetching user products: $e');
    } finally {
      isLoading = false;
      notifyListeners(); // Notify UI that loading is complete
    }
  }
}
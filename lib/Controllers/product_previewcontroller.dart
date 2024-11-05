import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductPreviewController extends ChangeNotifier {
  // Variables to hold product data
  List<String> imageList = [];
  String dressTitle = '';
  String description = '';
  String price = '';
  String minimumOrderQuantity = '';
  List<Color> colorsList = [];
  List<String> sizesList = [];
  bool isLoading = true; // Add the isLoading flag

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to fetch data from Firebase
  Future<void> getData() async {
    isLoading = true; // Start loading
    notifyListeners();

    final user = _auth.currentUser;
    if (user == null) {
      isLoading = false; // End loading if user is not found
      notifyListeners();
      return;
    }

    CollectionReference productsRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('products');

    try {
      QuerySnapshot querySnapshot = await productsRef.get();
      final allData = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      if (allData.isNotEmpty) {
        final productData = allData[0];

        // Update product data
        imageList = List<String>.from(productData['image'] ?? []);
        dressTitle = productData['DressTitle'] ?? '';
        description = productData['projectDescription'] ?? '';
        price = productData['price'] ?? '';
        minimumOrderQuantity = productData['minimumorder'] ?? '';

        // Convert color codes from string to Color
        colorsList = List<String>.from(productData['Colors'] ?? [])
            .map((colorCode) => Color(int.parse("0xff$colorCode")))
            .toList();

        // Get sizes
        sizesList = List<String>.from(productData['Sizes'] ?? []);
      }
    } catch (e) {
      print("Error getting data: $e");
    } finally {
      isLoading = false; // End loading
      notifyListeners();
    }
  }
}

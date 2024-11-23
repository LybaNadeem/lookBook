import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerHomeController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Wishlist product IDs
  List<dynamic> wishlist = [];

  // List of products
  List<Map<String, dynamic>> products = [];

  // Fetch current user ID
  String get currentUserId => _auth.currentUser?.uid ?? '';

  // Fetch wishlist and product details
  Future<void> fetchWishlistProducts() async {
    try {
      if (currentUserId.isEmpty) {
        throw Exception("User is not logged in");
      }

      // Get user's wishlist from Firestore
      final userDoc = await _firestore.collection('users').doc(currentUserId).get();

      if (userDoc.exists) {
        wishlist = userDoc.data()?['wishlist'] ?? [];
        print("Wishlist IDs: $wishlist");

        if (wishlist.isNotEmpty) {
          // Fetch product details using whereIn query
          final querySnapshot = await _firestore
              .collection('products')
              .where(FieldPath.documentId, whereIn: wishlist)
              .get();

          products = querySnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();

          print("Products fetched: $products");
        } else {
          print("No items in wishlist");
        }
      } else {
        print("User document not found");
      }
    } catch (e) {
      print("Error fetching wishlist products: $e");
    }
  }
}

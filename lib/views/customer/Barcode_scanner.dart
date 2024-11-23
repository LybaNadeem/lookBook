import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/views/customer/customer_home.dart';

class BarcodeScannerPage extends StatefulWidget {
  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  bool _isNavigating = false; // Flag to prevent multiple navigations
  // Function to handle adding a product to the wishlist
  Future<void> _addProductToWishlistByBarcode(String barcode) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        print("User is not logged in.");
        return;
      }

      final String userId = currentUser.uid;

      // Step 1: Query the product collection to find the product with the matching barcode
      final QuerySnapshot productQuery = await firestore
          .collection('products')
          .where('Barcode', isEqualTo: barcode)
          .get();

      if (productQuery.docs.isEmpty) {
        print("No product found with the provided barcode.");
        return;
      }

      final DocumentSnapshot productDoc = productQuery.docs.first;
      final String productId = productDoc.id;

      // Step 2: Get the current user's document
      final DocumentReference userDocRef =
      firestore.collection('users').doc(userId);

      final DocumentSnapshot userDocSnapshot = await userDocRef.get();

      // Step 3: Check if the `wishlist` field exists
      if (userDocSnapshot.exists) {
        Map<String, dynamic> userData =
        userDocSnapshot.data() as Map<String, dynamic>;

        if (userData.containsKey('wishlist')) {
          // If the wishlist exists, update it by adding the product ID if not already added
          List<dynamic> wishlist = userData['wishlist'];
          if (!wishlist.contains(productId)) {
            wishlist.add(productId);
            await userDocRef.update({'wishlist': wishlist});
            print("Product added to the existing wishlist.");
          } else {
            print("Product is already in the wishlist.");
          }
        } else {
          // If the wishlist field doesn't exist, create it and add the product ID
          await userDocRef.update({'wishlist': [productId]});
          print("Wishlist created and product added.");
        }
      } else {
        // If the user document doesn't exist (unlikely, but for safety)
        await userDocRef.set({'wishlist': [productId]});
        print("User document created with wishlist and product added.");
      }
    } catch (e) {
      print("Error adding product to wishlist: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Barcode'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          MobileScanner(
          onDetect: (BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && !_isNavigating) {
    final String? code = barcodes.first.rawValue;
    if (code != null) {
    print('Scanned Code: $code');
    setState(() {
    _isNavigating = true; // Set the flag to true
    });

    // Fetch product details using the barcode
    await _addProductToWishlistByBarcode(code);

    // Navigate to CustomerHomePage with the scanned code (optional)
    Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
    builder: (context) => CustomerHomePage(),
    ),
    (route) => false, // Clear previous routes
    );
    } else {
    print('No valid barcode detected.');
    }
    }
    },
    ),





          // Optional: Add an SVG or overlay for visual guidance
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.03,
            left: 0,
            right: 0,
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/barcode.svg',
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.width * 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
  //

}

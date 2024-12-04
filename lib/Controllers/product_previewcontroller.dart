import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductPreviewController extends ChangeNotifier {
  bool isLoading = true;
  List<String> imageList = [];
  String dressTitle = '';
  String description = '';
  double price = 0.0;
  int minimumOrderQuantity = 0;
  List<Color> colorsList = [Colors.red, Colors.green, Colors.blue]; // Example colors
  List<String> sizesList = ['S', 'M', 'L']; // Example sizes
  String instagram = '';
  String linkedin = '';
  String barcode = '';
  String photographerImageUrl = '';
  String photographerName = '';
  String photographerAbout = '';
  String photographerEmail = '';
  String photographerPhone = '';
  String photographerSocialLink = '';



  Future<void> getPhotographer(var productId, var photographerId) async {
    isLoading = true;


    try {
      print("Fetching photographer data from Firestore...");
      final photographerDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .collection('Photographer')
          .doc(photographerId) // Use photographerId here to get a specific document
          .get();

      if (photographerDoc.exists) {
        print("Photographer Document data: ${photographerDoc.data()}");

        final data = photographerDoc.data();

        // Parsing fields
        photographerName = data?['photographerName'] ?? '';
        photographerImageUrl = data?['imageUrl'] ?? '';
        photographerAbout = data?['about'] ?? '';
        photographerEmail = data?['email'] ?? '';
        photographerPhone = data?['phone'] ?? '';
        photographerSocialLink = data?['socialLink'] ?? '';


        print("Photographer fetched and parsed successfully.");
      } else {
        print("Photographer does not exist.");
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      isLoading = false;
     // Notify UI that loading is complete
    }
  }


  Future<void> getData(var productId) async {
    isLoading = true;
    notifyListeners(); // Notify UI to show loading state

    try {
      print("Fetching data from Firestore...");
      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)// Replace with actual document ID
          .get();

      if (doc.exists) {
        print("Document data: ${doc.data()}");

        // Parsing fields
        dressTitle = doc['DressTitle'] ?? '';
        description = doc['projectDescription'] ?? '';
        price = double.tryParse(doc['price'].toString()) ?? 0.0;
        minimumOrderQuantity = int.tryParse(doc['minimumorder'].toString()) ?? 0;

        instagram = doc['instagram'] ?? '';
        linkedin = doc['linkedin'] ?? '';
        barcode = doc['barcode'] ?? '';

        // Parsing arrays
        imageList = List<String>.from(doc['image'] ?? []);
        colorsList = (doc['Colors'] as List)
            .map((color) => Color(int.parse(color, radix: 16)))
            .toList();
        sizesList = List<String>.from(doc['Sizes'] ?? []);

        // Notify listeners to update the UI
        notifyListeners();
        print("Data fetched and parsed successfully.");
      } else {
        print("Document does not exist.");
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      isLoading = false;
      notifyListeners(); // Notify UI that loading is complete
    }
  }




}
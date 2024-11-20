import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class edit_controller extends ChangeNotifier {
  bool isLoading = true;
  List<String> imageList = [];
  String dressTitle = '';
  String description = '';
  double price = 0.0;
  int minimumOrderQuantity = 0;
  DateTime? eventDate; // Added for event date
  List<Color> colorsList = [Colors.red, Colors.green, Colors.blue]; // Example colors
  List<String> sizesList = ['S', 'M', 'L']; // Example sizes

  // Photographer fields
  String photographerName = '';
  String photographerEmail = '';
  String photographerPhone = '';
  String photographerSocialLink = '';

  Future<void> fetchData(var productId) async {
    isLoading = true;
    notifyListeners(); // Notify UI to show loading state

    try {
      // Fetch the main product document
      final productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();

      if (productDoc.exists) {
        final data = productDoc.data()!;
        dressTitle = data['DressTitle'] ?? '';
        description = data['projectDescription'] ?? '';
        price = double.tryParse(data['price'].toString()) ?? 0.0;
        minimumOrderQuantity = int.tryParse(data['minimumorder'].toString()) ?? 0;
        imageList = List<String>.from(data['image'] ?? []);
        colorsList = (data['Colors'] as List)
            .map((color) => Color(int.parse(color, radix: 16)))
            .toList();
        sizesList = List<String>.from(data['Sizes'] ?? []);
        eventDate = data['eventDate'] != null
            ? (data['eventDate'] as Timestamp).toDate()
            : null;
      }

      // Fetch the first photographer subcollection entry
      final photographerSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .collection('Photographer')
          .get();

      if (photographerSnapshot.docs.isNotEmpty) {
        final photographerData = photographerSnapshot.docs.first.data();
        photographerName = photographerData['photographerName'] ?? '';
        photographerEmail = photographerData['email'] ?? '';
        photographerPhone = photographerData['phone'] ?? '';
        photographerSocialLink = photographerData['socialLink'] ?? '';
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      isLoading = false;
      notifyListeners(); // Notify UI that loading is complete
    }
  }

  Future<void> updateProduct(var productId, Map<String, dynamic> updatedData) async {
    isLoading = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .update(updatedData);

      print('Product updated successfully!');
    } catch (e) {
      print('Error updating product: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

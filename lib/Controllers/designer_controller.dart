import 'package:cloud_firestore/cloud_firestore.dart';

class DesignerController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch designers dynamically by checking their role
  Future<List<Map<String, String>>> getDesigners() async {
    try {
      // Query the 'user' collection for users with the 'role' field set to 'designer'
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'designer')
          .get();

      // Map the documents into a list of maps
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'name': (data['name'] ?? 'Unknown').toString(),
          'phone': (data['phone'] ?? 'No phone').toString(),
          'image': (data['profileImage'] ?? 'https://via.placeholder.com/150').toString(),
        };
      }).toList();
    } catch (e) {
      print('Error fetching designers: $e');
      return [];
    }
  }

  // Fetch a specific designer by userId
  Future<Map<String, String>> getDesignerById(String userId) async {
    try {
      // Get the document with the specified userId
      DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'fullName': (data['name'] ?? 'Unknown').toString(),
          'phone': (data['phone'] ?? 'No phone').toString(),
          'profileImage': (data['profileImage'] ?? 'https://via.placeholder.com/150').toString(),
        };
      } else {
        throw Exception('Designer not found');
      }
    } catch (e) {
      print('Error fetching designer by ID: $e');
      throw e;
    }
  }
}
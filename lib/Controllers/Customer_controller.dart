import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all users whose role is 'customer'
  Future<List<Map<String, dynamic>>> getCustomersByRole(String role) async {
    try {
      // Query the 'users' collection for users with the 'role' field set to 'customer'
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: role) // Filtering by role
          .get();

      // Map the documents into a list of maps
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'fullName': data['fullName'] ?? 'Unknown',
          'phone': data['phone'] ?? 'No phone',
          'profileImage':
          data['profileImage'] ?? 'https://via.placeholder.com/150',
          'userId': doc.id, // Include the user ID
        };
      }).toList();
    } catch (e) {
      print('Error fetching customers: $e');
      return [];
    }
  }
}

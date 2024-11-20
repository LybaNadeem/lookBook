import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import

class ProfileCustomerScreen extends StatefulWidget {
  @override
  _ProfileCustomerScreenState createState() => _ProfileCustomerScreenState();
}

class _ProfileCustomerScreenState extends State<ProfileCustomerScreen> {
  User? currentUser;
  Map<String, dynamic>? profileData; // Store fetched profile data
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  /// Fetch current user data and check role
  Future<void> fetchProfileData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Get the currently logged-in user
      currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Fetch user document from Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .get();

        if (userDoc.exists) {
          // Check if the role is "customer"
          final data = userDoc.data();
          if (data != null && data['role'] == 'Customer') {
            setState(() {
              profileData = data; // Assign profile data
            });
          } else {
            // Handle case where the user is not a customer
            print("User is not a customer");
          }
        } else {
          print("User document does not exist");
        }
      } else {
        print("No user is logged in.");
      }
    } catch (e) {
      print("Error fetching profile data: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "LOOK\n      BOOK",
          style: TextStyle(fontFamily: 'Agne', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : profileData == null
          ? Center(child: Text("No profile data found or user is not a customer"))
          : SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              color: Colors.white, // White background
              padding: EdgeInsets.only(top: 100, left: 20, right: 20),
              child: Column(
                children: [
                  // White container
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF4C3A7),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.only(
                        top: 70, left: 20, right: 20), // Add top padding to avoid the avatar
                    child: Column(
                      children: [
                        // Name Field
                        buildTextField(
                            profileData?['name'] ?? 'No Name', Icons.edit),
                        SizedBox(height: 10),

                        // Email Field
                        buildTextField(
                            profileData?['email'] ?? currentUser?.email ?? 'No Email',
                            Icons.edit),
                        SizedBox(height: 10),

                        // Phone Field (if available)
                        buildTextField(
                            profileData?['phone'] ?? 'No Phone', Icons.edit),
                        SizedBox(height: 10),

                        // Password Field (obfuscated)
                        buildTextField('**************', Icons.edit),
                        SizedBox(height: 15),

                        // Update Button
                        ElevatedButton(
                          onPressed: () {
                            // Add update functionality if needed
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50), // Full width
                            backgroundColor: Color(0xFFE47F46), // Orange color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'UPDATE',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Title above the CircleAvatar
            Positioned(
              top: 20, // Adjust the position as needed
              child: Center(
                child: Text(
                  'PROFILE',
                  style: TextStyle(
                    fontFamily: 'TenorSans',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            // Profile Image Positioned
            Positioned(
              top: 60, // Adjust as needed to control overlap
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        profileData?['photoURL'] ??
                            currentUser?.photoURL ??
                            'https://via.placeholder.com/150'), // Placeholder if no photoURL
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 15,
                      child: Icon(Icons.edit, color: Colors.blue, size: 15),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String placeholder, IconData icon) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        hintText: placeholder,
        suffixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

}

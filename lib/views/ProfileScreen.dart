import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUserData();
  }

  void getCurrentUserData() {
    // Get the current user from FirebaseAuth
    currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      // If no user is logged in, handle appropriately (e.g., redirect to login)
      print("No user is currently logged in.");
    }

    setState(() {});
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
      body: currentUser == null
          ? Center(child: Text("No user logged in"))
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
                            currentUser?.displayName ?? 'No Name', Icons.edit),
                        SizedBox(height: 10),

                        // Email Field
                        buildTextField(currentUser?.email ?? 'No Email', Icons.edit),
                        SizedBox(height: 10),

                        // Phone Field (if available)
                        buildTextField(currentUser?.phoneNumber ?? 'No Phone', Icons.edit),
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

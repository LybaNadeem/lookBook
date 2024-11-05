import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ProfileScreen extends StatelessWidget {
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
      body: SingleChildScrollView(
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
                    padding: EdgeInsets.only(top: 70, left: 20, right: 20), // Add top padding to avoid the avatar
                    child: Column(
                      children: [
                        // Name Field
                        buildTextField('Jhone Rick', Icons.edit),
                        SizedBox(height: 10),

                        // Email Field
                        buildTextField('willie.jennings@example.com', Icons.edit),
                        SizedBox(height: 10),

                        // Phone Field
                        buildTextField('03157348409', Icons.edit),
                        SizedBox(height: 10),

                        // Password Field
                        buildTextField('**************', Icons.edit),
                        SizedBox(height: 10),

                        // Instagram Field
                        buildTextField('instagram.com/Jhon', Icons.edit),
                        SizedBox(height: 10),

                        // LinkedIn Field
                        buildTextField('linkedin.com/Jhon', Icons.edit),
                        SizedBox(height: 15),

                        // Add Social Links
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Add Social Links',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.add_circle_outline, color: Colors.orange),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Update Button
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50), // Full width and height of 50
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
            Positioned(top: 60, // Adjust as needed to control overlap
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                    AssetImage('assets/images/Designer circle.png'), // Placeholder image
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
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomerProfileScreen extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "LOOK\n      BOOK",
          style: TextStyle(fontFamily: 'Agne', fontWeight: FontWeight.bold),
        ),

        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        alignment: Alignment.center, // Center all children in the stack
        children: [
          // Background Container to fill the space
          Container(
            color: Colors.white, // White background
          ),

          // Profile Container
          Positioned(
            top: 150, // Adjust top position for centering
            child: Container(
              height: 430, // Set the height of the container
              width: 380, // Set the width of the container
              decoration: BoxDecoration(
                color: Color(0xFFF4C3A7), // Light background
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
              padding: EdgeInsets.only(top:80, left: 20, right: 20), // Adjusted top padding
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // Align children to the top
                crossAxisAlignment: CrossAxisAlignment.start, // Align children to the left
                children: [
                  // Name Field
                  buildTextField('Jhone Rick', Icons.edit),
                  SizedBox(height: 20),

                  // Email Field
                  buildTextField('willie.jennings@example.com', Icons.edit),
                  SizedBox(height: 20),

                  // Phone Field
                  buildTextField('03157348409', Icons.edit),
                  SizedBox(height: 40),

                  // Update Button
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50), // Full width and height of 50
                      backgroundColor: Color(0xFFE47F46), // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'UPDATE',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
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

          // Profile Image Positioned
          Positioned(
            top: 100, // Adjust as needed to control overlap
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/Designer circle.png'), // Placeholder image
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

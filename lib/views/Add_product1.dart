import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import the flutter_svg package
import 'AddProduct2.dart';

class AddProduct1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title:
          Text("LOOK\n      BOOK",
              style: TextStyle(
                  fontFamily: 'Agne', fontWeight: FontWeight.bold)),
        ), // AppBar title
       // Scaffold,
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding for aesthetics
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Align items to start
          crossAxisAlignment: CrossAxisAlignment.center, // Center items horizontally
          children: [
            // Title below AppBar with specific styles, centered
            Container(
              width: width * 0.6, // Adjust width relative to screen size
              height: height * 0.05, // Adjust height relative to screen size
              margin: EdgeInsets.only(bottom: height * 0.01), // Positioning from the bottom
              child: Opacity(
                opacity: 1.0, // Opacity set to 1 to make it visible
                child: Text(
                  'ADD PRODUCT',
                  style: TextStyle(
                    fontFamily: 'TenorSans',
                    fontSize: height * 0.03, // Adjust font size relative to screen height
                  ),
                  textAlign: TextAlign.center, // Center text
                ),
              ),
            ),
            // SVG icon below the title
            SvgPicture.asset(
              'assets/icons/3.svg', // Update with your SVG path
              height: height * 0.015, // Adjust the height relative to screen height
              width: width * 0.01,  // Minimize the width further
            ),

            SizedBox(height: height * 0.15), // Space to move the image down
            // Frame Image centered below the title
            Center(
              child: Container(
                width: width * 0.5, // Adjust width relative to screen size
                height: height * 0.25, // Adjust height relative to screen size
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Frame.png'), // Update with your image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.05), // Space below the image
            // Add New Project Button
            ElevatedButton(
              onPressed: () {
                // Navigate to AddProduct2 when button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProduct2()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE47F46), // Button color
                minimumSize: Size(width * 0.9, height * 0.07), // Button size relative to screen
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(width * 0.07), // Adjust border radius
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start, // Align items to start
                children: [
                  Text(
                    'ADD NEW PROJECT',
                    style: TextStyle(
                      fontFamily: 'Outfit-VariableFont_wght',
                      fontSize: height * 0.02, // Adjust font size relative to screen
                      fontWeight: FontWeight.w600,
                      color: Colors.white, // Text color
                    ),
                  ),
                  Spacer(), // Use Spacer for better alignment
                  SvgPicture.asset(
                    'assets/icons/addition.svg', // Update with your SVG path
                    height: height * 0.03, // Adjust icon height
                    width: width * 0.03, // Adjust icon width
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import the flutter_svg package
import 'AddProduct2.dart';

class AddProduct1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "LOOK\n      BOOK",
          style: TextStyle(fontFamily: 'Agne', fontWeight: FontWeight.bold),
        ),
      ), // AppBar title
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final width = constraints.maxWidth;

          return Padding(
            padding: const EdgeInsets.all(16.0), // Add padding for aesthetics
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Align items to start
              crossAxisAlignment: CrossAxisAlignment.center, // Center items horizontally
              children: [
                // Title below AppBar with specific styles, centered
                Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Centers both elements vertically
                  crossAxisAlignment: CrossAxisAlignment.center, // Centers both elements horizontally
                  children: [
                    Container(
                      width: width * 0.6, // Adjust width relative to screen size
                      height: height * 0.04, // Adjust height relative to screen size
                      margin: EdgeInsets.only(bottom: 0), // No space between the text and the SVG icon
                      child: Opacity(
                        opacity: 1.0, // Fully visible
                        child: Text(
                          'ADD PRODUCT',
                          style: TextStyle(
                            fontFamily: 'TenorSans',
                            fontSize: height * 0.03, // Adjust font size relative to screen height
                          ),
                          textAlign: TextAlign.center, // Center the text horizontally
                        ),
                      ),
                    ),
                    // SVG icon directly below the title
                    SvgPicture.asset(
                      'assets/icons/3.svg', // Path to your SVG asset
                      height: height * 0.015, // Adjust the height relative to screen height
                      width: width * 0.009, // Minimize the width further if needed
                      fit: BoxFit.contain, // Ensures the SVG fits the container size
                    ),
                  ],
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
                    backgroundColor: const Color(0xFFE47F46), // Orange color
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0), // Fixed padding for consistent look
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Rounded corners
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max, // Makes the Row take the maximum available width
                    mainAxisAlignment: MainAxisAlignment.center, // Center-align content
                    children: [
                      Text(
                        'ADD NEW PRODECT',
                        style: const TextStyle(
                          fontFamily: 'TenorSans',
                          fontSize: 18,
                          color: Colors.white,
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
          );
        },
      ),
    );
  }
}

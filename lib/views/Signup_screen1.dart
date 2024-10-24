import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Add this import for SVG support
import 'Signup_screen2.dart'; // Import the SignupScreen2

class SignupScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Image section
          Container(
            width: 430,
            height: 424,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/main picture.png'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 70), // Space between image and text

          // Text section
          Text(
            'Create With',
            style: TextStyle(
              fontFamily: 'Agne',
              fontSize: 50,
              fontWeight: FontWeight.bold,
              height: 1.36, // Line height
              letterSpacing: 1.21,
            ),
          ),

          SizedBox(height: 40), // Space between text and buttons

          // Designer Button
          Center(
            child: SizedBox(
              width: 360,
              height: 58,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignupScreen2(role: 'Designer'), // Navigate to SignupScreen2 with 'Designer' role
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE47F46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Designer',
                      style: TextStyle(
                        fontFamily: 'Outfit-Variable-wght',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 170.0), // Adjusted space between text and icon
                      child: SvgPicture.asset(
                        'assets/icons/arrow_icon.svg',
                        width: 16,
                        height: 16, // Arrow icon
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 15), // Space between buttons

          // Customer Button
          Center(
            child: SizedBox(
              width: 360,
              height: 58,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignupScreen2(role: 'Customer'), // Navigate to SignupScreen2 with 'Customer' role
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE47F46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Customer',
                      style: TextStyle(
                        fontFamily: 'Outfit-Variable-wght',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 170.0), // Adjusted space between text and icon
                      child: SvgPicture.asset(
                        'assets/icons/arrow_icon.svg',
                        width: 16,
                        height: 16, // Arrow icon
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

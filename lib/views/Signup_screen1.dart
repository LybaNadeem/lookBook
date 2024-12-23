import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Add this import for SVG support
import 'customer/Signup_up screen.dart';
class SignupScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get screen width and height dynamically
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image section
              Container(
                width: screenWidth, // Full width based on screen size
                height: screenHeight * 0.5, // 40% of the screen height
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/main picture.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              SizedBox(height: 20), // Space between image and text
              // Text section
              Text(
                'Create With',
                style: TextStyle(
                  fontFamily: 'Agne',
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  height: 1.36, // Line height
                  letterSpacing: 1.21,
                ),
              ),
              SizedBox(height: 20), // Space between text and buttons
              // Designer Button
              Center(
                child: SizedBox(
                  width: screenWidth * 0.8, // 80% of the screen width
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupScreen(role: 'Designer'), // Navigate with 'Designer' role
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
                        Spacer(), // Creates space between text and icon
                        SvgPicture.asset(
                          'assets/icons/arrow_icon.svg',
                          width: 16,
                          height: 16, // Arrow icon
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
                  width: screenWidth * 0.8, // 80% of the screen width
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupScreen(role: 'Customer'), // Navigate with 'Customer' role
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
                        Spacer(), // Creates space between text and icon
                        SvgPicture.asset(
                          'assets/icons/arrow_icon.svg',
                          width: 16,
                          height: 16, // Arrow icon
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Space at the bottom for better scrolling experience
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color foregroundColor; // Added foreground color for the text
  final VoidCallback onPressed;

  const CustomButton({
    required this.text,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen dimensions
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Set the button dimensions and font size based on screen size
    final double buttonHeight = screenHeight * 0.07; // 7% of screen height
    final double buttonWidth = screenWidth * 0.8; // 80% of screen width
    final double fontSize = screenWidth * 0.05; // Font size relative to screen width

    return SizedBox(
      width: buttonWidth, // Set the button width
      height: buttonHeight, // Set the button height
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 18), // No vertical padding to use the full height
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fontSize), // Set the font size
        ),
      ),
    );
  }
}

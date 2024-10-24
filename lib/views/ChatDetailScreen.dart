import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Keep this only if you're using SVGs

class ChatDetailScreen extends StatelessWidget {
  final String name;
  final String imageUrl;

  ChatDetailScreen({required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "LOOK\n      BOOK",
          style: TextStyle(fontFamily: 'Agne', fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding for aesthetics
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align items to start
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                child: Column(
                  children: [
                    // Title below AppBar
                    Container(
                      margin: EdgeInsets.only(bottom: 5), // Positioning from the bottom
                      child: Text(
                        'MESSAGES',
                        style: TextStyle(fontFamily: 'TenorSans', fontSize: 24),
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/icons/3.svg', // Update with your SVG path
                      height: height * 0.01, // Adjust the height as needed
                      width: width * 0.02, // Adjust the width as needed
                    ),
                  ],
                ),
              ),
              // You can add more widgets here for the chat UI
              // For example, a list of messages, input field, etc.
            ],
          ),
        ),
      ),
    );
  }
}

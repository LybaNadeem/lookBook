import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/views/login_screen.dart';

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white, // Set a background color for the page
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    // Close Icon
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(); // Close the page
                          },
                          child: Icon(
                            Icons.close, // Close icon
                            size: 30.0,
                            color: Colors.black, // Color of the icon
                          ),
                        ),
                      ],
                    ),
                    // Title Section (moved below Close Icon)
                    Padding(
                      padding: const EdgeInsets.all(16.0), // Padding for title
                      child: Text(
                        "LOOK\n      BOOK",
                        style: TextStyle(
                          fontFamily: 'Agne',
                          fontSize: 20, // Font size for better visibility
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // About Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            'About Fashion Concierge',
                            style: TextStyle(
                              fontFamily: 'Outfit_Variable_wght',
                              color: Color(0xFFE47F46),
                            ),
                          ),
                          onTap: () {
                            // Navigate to an About page or display relevant content
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 8.0), // Padding for description
                          child: Text(
                            'We work with monitoring programmes to ensure compliance with safety, health and quality standards for our products. '
                                'The Designer is responsible for adding products to the app. While they handle product-related tasks, they have no influence over the app\'s UI or UX design decisions.',
                            style: TextStyle(
                              fontFamily: 'TenorSans', // Consistent font
                              color: Colors.black, // Text color
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    // TextField with Dropdown for Language Selection
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Padding for the whole section
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align "Language" text to the left
                        children: [
                          // Text Label
                          Text(
                            'Selected Language',
                            style: TextStyle(color: Colors.black, fontSize: 16.0), // You can adjust font size
                          ),
                          SizedBox(height: 8.0), // Small spacing between label and TextField
                          // TextField with Dropdown
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey, // Border color
                                width: 1.0, // Border width
                              ),
                              borderRadius: BorderRadius.circular(30), // Rounded corners
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16 ,vertical: 8),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: 'English', // Set a default value for UI
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down,  color: Colors.grey,),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle( color: Colors.grey, fontSize: 16),
                                onChanged: null, // No logic for changes, keeps the dropdown functional
                                items: ['English', 'Spanish', 'French'].map<DropdownMenuItem<String>>((String language) {
                                  return DropdownMenuItem<String>(
                                    value: language,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      child: Text(language),
                                    ),
                                  );
                                }).toList(),
                                dropdownColor: Colors.white, // Dropdown background color
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Logout Button at the bottom
               Row(
                 children: [
                   Padding(
                     padding: const EdgeInsets.all(12.0),
                     child: ElevatedButton(
                       onPressed: () async {
                         // Handle logout functionality
                         try {
                           await FirebaseAuth.instance.signOut(); // Sign out the user
                           Navigator.pushReplacement(
                             context,
                             MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate to LoginScreen
                           );
                         } catch (e) {
                           print("Error during logout: $e");
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(content: Text("Error during logout: $e")),
                           );
                         }
                       },
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Color(0xFFE47F46), // Orange color for button
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(30), // Rounded button shape
                         ),
                         minimumSize: Size(40, 50), // Full-width button with height
                       ),
                       child: Text(
                         'LOGOUT',
                         style: TextStyle(color: Colors.white),
                       ),
                     ),

                   ),
                 ],
               ),

            ],
          ),
        ),
      ),
    );
  }
}
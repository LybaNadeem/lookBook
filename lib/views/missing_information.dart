import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'Add_product1.dart'; // Import for SVG icons, if needed

class MissInformationScreen extends StatefulWidget {
  final String userId;

  MissInformationScreen({required this.userId});

  @override
  _MissInformationScreenState createState() => _MissInformationScreenState();
}

class _MissInformationScreenState extends State<MissInformationScreen> {
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();

  @override
  void dispose() {
    _instagramController.dispose();
    _linkedinController.dispose();
    super.dispose();
  }

  // Function to submit missing information
  Future<void> _submitInformation() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
        'instagram': _instagramController.text,
        'linkedin': _linkedinController.text,
        'isInformationComplete': true, // Mark as complete
      });

      // Navigate to AddProduct1 after successful update
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AddProduct1()), // Change to AddProduct1
      );
    } catch (e) {
      print("Error updating information: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }


  // Custom input field widget with optional suffix icon
  Widget customInputField({
    required String hintText,
    required TextEditingController controller,
  }) {
    return Container(
      height: 50,
      width: double.infinity,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(70),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(70),
            borderSide: BorderSide(color: Colors.orange, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(70),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section
            Container(
              width: double.infinity,
              height: height * 0.3,
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.only(left: 35.0, top: 84.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FILL YOUR MISSING INFORMATION',
                      style: TextStyle(
                        fontFamily: 'Agne',
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10), // Add space between text and new container
                    // Add the new Container here
                    Container(
                      height:height*0.03,
                      width:width*0.35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "Required Fields ",
                              style: TextStyle(
                                fontFamily: 'TenorSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Instagram', style: TextStyle(fontFamily: 'TenorSans', fontSize: 16)),
                  SizedBox(height: 5),
                  customInputField(
                    hintText: 'Type your Instagram',
                    controller: _instagramController,
                  ),
                  SizedBox(height: 20),
                  Text('LinkedIn', style: TextStyle(fontFamily: 'TenorSans', fontSize: 16)),
                  SizedBox(height: 5),
                  customInputField(
                    hintText: 'Type your LinkedIn profile',
                    controller: _linkedinController,
                  ),
                  SizedBox(height: 20),


              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _submitInformation, // Submit information
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE47F46),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Adjusts the Row size
                    mainAxisAlignment: MainAxisAlignment.center, // Centers the content
                    children: [
                      Text(
                        'UPDATE',
                        style: TextStyle(
                          fontFamily: 'Outfit_Variable_wght',
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 178), // Space between text and icon
                      SvgPicture.asset(
                        'assets/icons/arrow_icon.svg', // Path to your SVG
                        width: 16, // Set width of the icon
                        height: 16, // Set height of the icon
                        color: Colors.white, // Optional: Change the icon color
                      ),
                    ],
                  ),
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
}

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../Controllers/Profiledesigner_controller.dart';
import 'package:flutter_svg/flutter_svg.dart'; //
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileDesignerController _controller = ProfileDesignerController();
  User? currentUser;
  Map<String, dynamic>? profileData;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    currentUser = _controller.getCurrentUser();
    if (currentUser != null) {
      final data = await _controller.getUserProfile();
      setState(() {
        profileData = data;
        _fullNameController.text = data?['fullName'] ?? '';
        _emailController.text = currentUser?.email ?? '';
        _phoneController.text = data?['phone'] ?? '';
        _instagramController.text = data?['instagram'] ?? '';
        _linkedinController.text = data?['linkedin'] ?? '';
      });
    } else {
      print("No user is currently logged in.");
    }
  }

  Future<void> updateProfile() async {
    await _controller.updateUserProfile(
      fullName: _fullNameController.text,
      instagram: _instagramController.text,
      linkedin: _linkedinController.text,
      phone: _phoneController.text,
    );

    // Optionally update email and Firebase Auth details
    if (currentUser?.email != _emailController.text) {
      await _controller.updateEmail(_emailController.text);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  // Pick image from gallery
  Future<void> pickImage() async {
    await _controller.pickImageForProfile(); // Now use the public method
    loadUserData(); // Refresh user data after updating the image
  }

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
      body: currentUser == null
          ? Center(child: Text("No user logged in"))
          : SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 100, left: 20, right: 20),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF4C3A7),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.only(top: 70, left: 20, right: 20),
                    child: Column(
                      children: [
                        buildTextField(
                          controller: _fullNameController,
                          label: 'Full Name',
                          icon: Icons.person,
                        ),
                        SizedBox(height: 10),
                        buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          icon: Icons.email,
                        ),
                        SizedBox(height: 10),
                        buildTextField(
                          controller: _phoneController,
                          label: 'Phone',
                          icon: Icons.phone,
                        ),
                        SizedBox(height: 10),
                        buildTextField(
                          controller: _instagramController,
                          label: 'Instagram',
                          icon: Icons.camera_alt,
                        ),
                        SizedBox(height: 10),
                        buildTextField(
                          controller: _linkedinController,
                          label: 'LinkedIn',
                          icon: Icons.work,
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Add Social links',
                                style: TextStyle(
                                  fontFamily: 'TenorSans',
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(width: 8),  // Space between the text and the icon
                            GestureDetector(
                              onTap: () {
                                // Show the bottom sheet when the SVG icon is tapped
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    final height = MediaQuery.of(context).size.height;
                                    final width = MediaQuery.of(context).size.width;

                                    return Container(
                                      height: 350, // Set the desired fixed height for the bottom sheet
                                      width: double.infinity, // Full width of the screen
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: SvgPicture.asset(
                                              'assets/icons/bottom sheet.svg',
                                              width: 151,
                                              height: 4,
                                            ),
                                          ),
                                          SizedBox(height: 64),
                                          Text(
                                            'Add Social Link',
                                            style: TextStyle(
                                              fontFamily: 'TenorSans',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          TextField(
                                            decoration: InputDecoration(
                                              hintText: 'Title',
                                              hintStyle: TextStyle(
                                                  fontFamily: 'TenorSans',
                                                  color: Colors.grey[400],
                                                  fontSize: 14
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30.0),
                                                borderSide: BorderSide(color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          TextField(
                                            decoration: InputDecoration(
                                              hintText: 'Link',
                                              hintStyle: TextStyle(
                                                  fontFamily: 'TenorSans',
                                                  color: Colors.grey[400],
                                                  fontSize: 14
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30.0),
                                                borderSide: BorderSide(color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Center(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                // Handle the button action here
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(0xFFE47F46),
                                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                minimumSize: Size(399, 59),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'ADD',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontFamily: 'Outfit_Variable_wght',
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  SvgPicture.asset(
                                                    'assets/icons/white Vector.svg',
                                                    height: 24,
                                                    width: 24,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: SvgPicture.asset(
                                'assets/icons/Vector.svg',
                                width: 24,  // Adjust the width of the icon
                                height: 24,  // Adjust the height of the icon
                              ),
                            ),
                          ],
                        ),


                        SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: updateProfile,
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            backgroundColor: Color(0xFFE47F46),
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
            Positioned(
              top: 20,
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
            Positioned(
              top: 60,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      profileData?['photoURL'] ??
                          'https://via.placeholder.com/150',
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: pickImage, // Call pickImage when clicked
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 15,
                        child: Icon(Icons.edit, color: Colors.blue, size: 15),
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

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(

        floatingLabelBehavior: FloatingLabelBehavior.always, // Ensure the label is always on top
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        suffixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

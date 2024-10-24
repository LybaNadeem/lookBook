import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'missing_information.dart'; // Ensure correct import path
import 'login_screen.dart'; // Ensure correct path to your LoginScreen

class SignupScreen2 extends StatefulWidget {
  final String role; // Role parameter

  SignupScreen2({required this.role}); // Constructor to accept the role

  @override
  _SignupScreen2State createState() => _SignupScreen2State();
}

class _SignupScreen2State extends State<SignupScreen2> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _emailController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Custom input field widget with optional suffix icon
  Widget customInputField({
    required String hintText,
    required TextEditingController controller,
    bool isObscured = false,
    Widget? suffixIcon,
  }) {
    return Container(
      height: 50,
      width: double.infinity,
      child: TextField(
        controller: controller,
        obscureText: isObscured,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(70),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.5), // Lighten the grey color
              width: 1.5,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(70),
            borderSide: BorderSide(color: Colors.orange, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(70),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  // Function to handle signup
  Future<void> _signup() async {
    final String fullName = _fullNameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final String phone = _phoneController.text;

    if (password != _confirmPasswordController.text) {
      // Passwords don't match
      print("Passwords do not match");
      return;
    }

    try {
      // Create a new user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save additional user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'UserID': userCredential.user!.uid,
        'role': widget.role,
        'isInformationComplete': false, // Initial value when signing up
      });

      print("User registered successfully: ${userCredential.user!.uid}");

      // Navigate to the Missing Information Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MissInformationScreen(userId: userCredential.user!.uid)),
      );
    } catch (e) {
      // Handle errors (e.g., weak password, email already in use)
      print("Error during signup: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.only(left: 35.0, top: 44.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontFamily: 'Agne',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        // Navigate back to login screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate to LoginScreen
                        );
                      },
                      child: Container(
                        height: 32,
                        width: 320,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "Already have an account? ",
                                style: TextStyle(
                                  fontFamily: 'TenorSans',
                                  fontSize: 16,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontFamily: 'TenorSans',
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            SvgPicture.asset(
                              'assets/icons/arrow_icon.svg',
                              width: 13,
                              height: 13,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Full Name', style: TextStyle(fontFamily: 'TenorSans', fontSize: 16)),
                  SizedBox(height: 5),
                  customInputField(
                    hintText: 'Type full name',
                    controller: _fullNameController,
                  ),
                  SizedBox(height: 20),
                  // Email Field
                  Text('Email', style: TextStyle(fontFamily: 'TenorSans', fontSize: 16)),
                  SizedBox(height: 5),
                  customInputField(
                    hintText: 'Type email',
                    controller: _emailController,
                  ),
                  SizedBox(height: 20),
                  Text('Phone Number', style: TextStyle(fontFamily: 'TenorSans', fontSize: 16)),
                  SizedBox(height: 5),
                  customInputField(
                    hintText: 'Type phone number',
                    controller: _phoneController,
                  ),

                  // Password Field
                  SizedBox(height: 5),

                  // Confirm Password Field
                  SizedBox(height: 20),
                  Text('Password', style: TextStyle(fontFamily: 'TenorSans', fontSize: 16)),
                  SizedBox(height: 5),
                  customInputField(
                    hintText: 'Type password',
                    controller: _passwordController,
                    isObscured: !_isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),

                  Text('Confirm Password', style: TextStyle(fontFamily: 'TenorSans', fontSize: 16)),
                  SizedBox(height: 5),
                  customInputField(
                    hintText: 'Type password',
                    controller: _confirmPasswordController,
                    isObscured: !_isConfirmPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),

                  // Signup Button
                  Center(
                    child: ElevatedButton(
                      onPressed: _signup, // Call signup method on button press
                      style: ElevatedButton.styleFrom(

                        backgroundColor: Color(0xFFE47F46),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Centers the text and icon
                        children: [
                          Text(
                            'SIGN UP NOW!',
                            style: TextStyle(
                              fontFamily: 'Outfit-Variable-wght',
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width:150), // Space between text and icon
                          SvgPicture.asset(
                            'assets/icons/arrow_icon.svg', // Path to your SVG
                            width: 16, // Set width of the icon
                            height: 16, // Set height of the icon
                            color: Colors.white, // Optional: Change the icon color if needed
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

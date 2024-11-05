import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../components/textfield.dart';
import '../login_screen.dart';
import '../missing_information.dart';

class SignupScreen extends StatefulWidget {
  final String role;

  SignupScreen({required this.role});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    final String fullName = _fullNameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();
    final String phone = _phoneController.text.trim();

    // Validate inputs
    if (fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill in all fields")));
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Passwords do not match")));
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'UserID': userCredential.user!.uid,
        'role': widget.role,
        'isInformationComplete': false,
      });

      print("User registered successfully: ${userCredential.user!.uid}");

      // Navigate to MissingInformationScreen after successful signup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MissInformationScreen(userId: userCredential.user!.uid)),
      );

    } catch (e) {
      print("Error during signup: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double paddingVertical = screenHeight * 0.02;
    double paddingHorizontal = screenWidth * 0.05;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section
            Container(
              width: double.infinity,
              height: screenHeight * 0.35,
              color: Colors.black,
              child: Padding(
                padding: EdgeInsets.only(left: paddingHorizontal, top: screenHeight * 0.12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontFamily: 'Agne',
                        fontSize: screenHeight * 0.04,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      child: Container(
                        height: 40.0,
                        width: 303,// Fixed height for better control
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0), // Consistent horizontal padding
                          child: Row(

                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  fontFamily: 'TenorSans',
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    " Signup",
                                    style: TextStyle(
                                      fontFamily: 'TenorSans',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 10.0), // Adjusted spacing
                                  SvgPicture.asset(
                                    'assets/icons/arrow_icon.svg',
                                    width: 16.0, // Consistent size for the icon
                                    height: 16.0,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: paddingVertical, horizontal: paddingHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Full Name', style: TextStyle(fontFamily: 'TenorSans', fontSize: screenHeight * 0.02)),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    hintText: 'Type full name',
                    controller: _fullNameController,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  // Email Field
                  Text('Email', style: TextStyle(fontFamily: 'TenorSans', fontSize: screenHeight * 0.02)),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    hintText: 'Type email',
                    controller: _emailController,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Text('Phone Number', style: TextStyle(fontFamily: 'TenorSans', fontSize: screenHeight * 0.02)),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    hintText: 'Type phone number',
                    controller: _phoneController,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Text('Password', style: TextStyle(fontFamily: 'TenorSans', fontSize: screenHeight * 0.02)),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    hintText: 'Type password',
                    controller: _passwordController,
                    isObscured: !_isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Text('Confirm Password', style: TextStyle(fontFamily: 'TenorSans', fontSize: screenHeight * 0.02)),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    hintText: 'Confirm password',
                    controller: _confirmPasswordController,
                    isObscured: !_isConfirmPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  // Sign Up Button
                  // Sign Up Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _signup(); // Call the _signup method
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE47F46), // Orange color
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0), // Fixed padding for consistent look
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded corners
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max, // Makes the Row take the maximum available width
                        mainAxisAlignment: MainAxisAlignment.center, // Center-align content
                        children: [
                          Text(
                            'SIGNUP NOW!',
                            style: const TextStyle(
                              fontFamily: 'TenorSans',
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          Spacer(), // Automatically adds flexible space between the text and icon
                          SvgPicture.asset(
                            'assets/icons/arrow_icon.svg',
                            width: 16, // Adjusted width for better visibility
                            height: 16, // Adjusted height for better visibility
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/views/HomePage.dart';
import 'Add_product1.dart';
import 'Admin/Dashboard.dart';
import 'Signup_screen1.dart'; // Import your HomePage
import 'customer/customer_home.dart';
import 'missing_information.dart';
import 'package:shared_preferences/shared_preferences.dart';// Import your Missing Information Page

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;


  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 250.0, // Fixed height to make it more adaptable
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 54.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start, // Align at the top to prevent overflow
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'LOGIN ACCOUNT',
                        style: TextStyle(
                          fontFamily: 'Agne',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20.0), // Fixed space for consistency
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignupScreen1()),
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
                padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email Text Field
                    Text('Email', style: TextStyle(fontFamily: 'TenorSans',fontSize: 16, color: Colors.grey[700])),
                    SizedBox(height:height * 0.010),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: ' Type Email',
                        hintStyle: TextStyle(fontFamily: 'TenorSans', color: Colors.grey[400], fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0), // Set radius for the border
                          borderSide: BorderSide(
                            color: Colors.grey, // Lighter border color
                          ),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0), // Same radius when enabled
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)), // Border color when enabled
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0), // Same radius when focused
                          borderSide: BorderSide(color: Colors.grey), // Same color when focused
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: height * 0.02),

                    // Password Text Field
                    Text('Password', style: TextStyle(fontFamily: 'TenorSans', fontSize: 16, color: Colors.grey[700])),
                    SizedBox(height: 5),
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: ' Type password',
                        hintStyle: TextStyle(fontFamily: 'TenorSans',color: Colors.grey[400], fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0), // Set radius for the border
                          borderSide: BorderSide(color: Colors.grey), // Default border color
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0), // Same radius when enabled
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)), // Border color when enabled
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0), // Same radius when focused
                          borderSide: BorderSide(color: Colors.grey), // Same color when focused
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );

                            User? user = userCredential.user;

                            if (user != null) {
                              // Check the user's document in Firestore
                              DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .get();

                              if (documentSnapshot.exists) {
                                Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                                String role = data['role'] ?? '';

                                // Save login state using SharedPreferences
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                await prefs.setBool('isLoggedIn', true);
                                await prefs.setString('userId', user.uid);
                                await prefs.setString('role', role);

                                // Navigate based on the role
                                bool hasMissingInformation = data['instagram'] == null || data['linkedin'] == null;

                                if (hasMissingInformation) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => MissInformationScreen(userId: user.uid)),
                                  );
                                } else {
                                  if (role == 'Designer') {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => HomePage()),
                                    );
                                  } else if (role == 'Customer') {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => CustomerHomePage()),
                                    );
                                  } else if (role == 'admin') {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => AdminDashboard()),
                                    );
                                  } else {
                                    print("Role is not assigned or invalid");
                                  }
                                }
                              } else {
                                print("Document does not exist");
                              }
                            }
                          } catch (e) {
                            print("Login failed: $e");
                          }
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
                              'LOGIN NOW!',
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
                    SizedBox(height: 20),
                    Center(
                      child: Container(
                        height: 31,
                        width: 145,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.withOpacity(0.5), width: 2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextButton(
                          onPressed: () {
                            _showForgotPasswordBottomSheet(context);
                          },
                          child: Text(
                            "Forgot Password",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9, fontFamily: 'TenorSans', color: Colors.black),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey[300],
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "OR",
                            style: TextStyle(fontFamily: 'TenorSans', color: Colors.grey[700], fontSize: 16),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey[300],
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: SvgPicture.asset(
                        'assets/icons/google and apple_icon.svg',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows modal to take up more height
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // To handle keyboard overlap
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0), // Added fixed padding
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Minimize the size to fit content
                children: [
                  Center(
                    child: SvgPicture.asset(
                      'assets/icons/bottom sheet.svg',
                      width: 151,
                      height: 4,
                    ),
                  ),
                  const SizedBox(height: 60), // Adds space between the SVG and text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the start (left)
                    children: [
                      const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontFamily: 'Agne',
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Enter your email for the verification process.\n'
                            'We will send a 4-digit code to your email.\n'
                            'Please check your inbox and enter the code to continue.',
                        textAlign: TextAlign.start, // Align text content to the start (left)
                        style: TextStyle(fontFamily: 'TenorSans', fontSize: 16),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'Email',
                        style: TextStyle(fontFamily: 'TenorSans', fontSize: 14),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: ' Type Email',
                          hintStyle: TextStyle(
                            fontFamily: 'TenorSans',
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0), // Set radius for the border
                            borderSide: const BorderSide(
                              color: Colors.grey, // Lighter border color
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0), // Same radius when enabled
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.5), // Border color when enabled
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0), // Same radius when focused
                            borderSide: const BorderSide(
                              color: Colors.grey, // Same color when focused
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
void _showLoginSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevents dialog from closing by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline, color: Colors.black, size: 50),
            SizedBox(height: 20),
            Text(
              'Login Successful',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'TenorSans',
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AddProduct1()), // Navigate to your homepage
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE47F46), // Orange color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0), // Added padding
              ),
              child: const Text(
                'DONE',
                style: TextStyle(color: Colors.white),
              ),
            ),

          ],
        ),
      );
    },
  );
}

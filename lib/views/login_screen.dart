import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Signup_screen1.dart';
import 'Add_product1.dart'; // Import your HomePage
import 'missing_information.dart'; // Import your Missing Information Page

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 250,
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.only(left: 35.0, top: 44.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      const SizedBox(height:2),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignupScreen1()),
                            );
                          },
                          child: Container(
                            height: 40,
                            width: 310,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    "Don't have an account? ",
                                    style: TextStyle(
                                      fontFamily: 'TenorSans',
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 0.5),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Signup",
                                        style: TextStyle(
                                          fontFamily: 'TenorSans',
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width:20),
                                      SvgPicture.asset(
                                        'assets/icons/arrow_icon.svg',
                                        width: 13,
                                        height: 13,
                                      ),
                                    ],
                                  ),
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
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email Text Field
                    Text('Email', style: TextStyle(fontFamily: 'TenorSans',fontSize: 16, color: Colors.grey[700])),
                    SizedBox(height: 5),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: ' Type Email',
                        hintStyle: TextStyle(fontFamily: 'TenorSans', color: Colors.grey[400], fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0), // Set radius for the border
                          borderSide: BorderSide(color: Colors.grey), // Default border color
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0), // Same radius when enabled
                          borderSide: BorderSide(color: Colors.grey), // Border color when enabled
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0), // Same radius when focused
                          borderSide: BorderSide(color: Colors.grey), // Same color when focused
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20),

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
                          borderSide: BorderSide(color: Colors.grey), // Border color when enabled
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
                              // Check for missing information in Firestore
                              DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .get();

                              if (documentSnapshot.exists) {
                                Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

                                // Debugging: Print user data
                                print("User data: $data");

                                List<String> fields = [
                                  'instagram',
                                  'linkedin',
                                ];

                                bool missingInformation = false;
                                for (String field in fields) {
                                  // Check for missing or empty fields
                                  if (!data.containsKey(field) || data[field] == null || data[field].isEmpty) {
                                    print("Missing information for field: $field"); // Debug: Print missing field
                                    missingInformation = true;
                                    break;
                                  }
                                }

                                if (missingInformation) {
                                  // Navigate to Missing Information Page
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => MissInformationScreen(userId: user.uid)),
                                  );
                                } else {
                                  // Navigate to Home Page
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => AddProduct1()),
                                  );
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
                          backgroundColor: Color(0xFFE47F46), // Set the color using hex code
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('LOGIN NOW!', style: TextStyle(fontFamily: 'Outfit-Variable-wght',fontSize: 18, color: Colors.white)),
                            Padding(
                              padding: EdgeInsets.only(left: 170.0),
                              child: SvgPicture.asset('assets/icons/arrow_icon.svg', width: 16, height: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextButton(
                          onPressed: () {
                            _showForgotPasswordBottomSheet(context);
                          },
                          child: Text(
                            "Forgot Password",
                            style: TextStyle(fontFamily: 'TenorSans', color: Colors.grey[700]),
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
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: 300,
          child: Column(
            children: [
              Text(
                'Forgot Password?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Enter your email to receive a password reset link.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle password reset
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text('Send Reset Link', style: TextStyle(fontFamily: 'TenorSans',fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }
}

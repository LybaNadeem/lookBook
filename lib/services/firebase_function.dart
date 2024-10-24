import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fashion App',
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login / Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
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
                  borderSide: BorderSide(color: Colors.orange), // Change border color when focused
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
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
                  borderSide: BorderSide(color: Colors.orange), // Change border color when focused
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Implement login functionality here
              },
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
            Text('or'),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to sign-up screen
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

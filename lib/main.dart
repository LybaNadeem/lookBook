import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/providers/onboarding_provider.dart';
import 'package:untitled/providers/auth_provider.dart';
import 'package:untitled/views/ProductPreview.dart';
import 'package:untitled/views/Signup_screen1.dart';
import 'package:untitled/views/Signup_screen2.dart';
import 'package:untitled/views/welcome_screen.dart';
import 'package:untitled/views/login_screen.dart';
import 'views/Add_product1.dart';
import 'views/AddProduct2.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/welcome', // Set initial route to Welcome Screen
        routes: {
          '/welcome': (context) => const WelcomeScreen(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen1(),
          '/signup2': (context) => SignupScreen2(role: 'designer',),
          '/homepage': (context) => AddProduct1(),
          '/homepage2': (context) => AddProduct2(),
          '/homepage3': (context) => ProductPreviewStateful(),

        },
      ),
    );

  }
}




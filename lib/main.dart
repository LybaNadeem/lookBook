import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/providers/onboarding_provider.dart';
import 'package:untitled/providers/auth_provider.dart';
import 'package:untitled/views/Add_product1.dart';
import 'package:untitled/views/Admin/Dashboard.dart';
import 'package:untitled/views/ProductPreview.dart';
import 'package:untitled/views/Signup_screen1.dart';
import 'package:untitled/views/customer/Signup_up%20screen.dart';
import 'package:untitled/views/customer/customer_home.dart';
import 'package:untitled/views/welcome_screen.dart';
import 'package:untitled/views/login_screen.dart';
import 'Controllers/product_previewcontroller.dart';
import 'views/AddProduct2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      String? role = prefs.getString('role');

      if (role == 'Designer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AddProduct1()),
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductPreviewController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/welcome',
        routes: {
          '/welcome': (context) => WelcomeScreen(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen1(),
          '/signup2': (context) => SignupScreen(role: 'designer'),
          '/homepage': (context) => AddProduct1(),
          '/homepage2': (context) => AddProduct2(),
          '/homepage3': (context) => ProductPreviewStateful(),
          '/homepage4': (context) => CustomerHomePage(),
          '/homepage5': (context) => AdminDashboard(),
        },
      ),
    );
  }
}

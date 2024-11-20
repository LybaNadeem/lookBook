import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/providers/Notification_provider.dart';
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
import 'Controllers/Homepage_controller.dart';
import 'Controllers/edit_controller.dart';
import 'Controllers/product_previewcontroller.dart';
import 'views/AddProduct2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async {
  await Firebase.initializeApp();
  print(message.notification!.title.toString());
 
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

      WidgetsBinding.instance.addPostFrameCallback((_) {
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductPreviewController()),
        ChangeNotifierProvider(create: (_) => edit_controller()),
        ChangeNotifierProvider(create: (_) => HomepageController()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
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

          '/homepage4': (context) => CustomerHomePage(),
          '/homepage5': (context) => AdminDashboard(),
        },
      ),
    );
  }
}

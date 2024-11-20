import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'MessageApp.dart';

class NotificationServices {
  // Initialising Firebase Messaging plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Initialising Flutter Local Notifications plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Function to initialise Flutter Local Notification Plugin for Android/iOS
  void initLocalNotifications(BuildContext context) async {
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MessagesApp(id: response.payload!)),
          );
        }
      },
    );

  }


  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      // Extract notification details
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (kDebugMode) {
        print("Notification title: ${notification?.title}");
        print("Notification body: ${notification?.body}");
        print("Data: ${message.data}");
      }

      if (notification != null) {
        if (Platform.isAndroid) {
          // Initialize and show notification for Android
          initLocalNotifications(context);
          showNotification(message);
        }
        if (Platform.isIOS) {
          // Enable foreground presentation options for iOS
          forgroundMessage();
        }
      }
    });
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted permission');
      }
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('User granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('User denied permission');
      }
    }
  }

  // Function to display a visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(10000).toString(), // Unique ID for each channel
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode, // Unique ID for the notification
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      notificationDetails,
      payload: message.data['id'], // Pass the message ID as payload
    );
  }

  // Function to get device token for sending notifications
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token ?? '';
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      if (kDebugMode) {
        print('Token refreshed: $event');
      }
    });
  }

  // Handle notification taps when app is in background or terminated
  Future<void> setupInteractMessage(BuildContext context) async {
    // When app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    // When app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(context, message);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'msj') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MessagesApp(
            id: message.data['id'], // Pass the ID to the MessagesApp
          ),
        ),
      );
    }
  }

  // Set foreground notification presentation options for iOS
  Future<void> forgroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  Future<void> triggerDynamicNotification(String title, String body, {String? payload}) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(10000).toString(), // Unique ID for each channel
      'Dynamic Notifications',
      description: 'Channel for dynamic notifications.',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      Random.secure().nextInt(10000), // Unique notification ID
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
  final String _serverKey =
      'YOUR_SERVER_KEY'; // Replace with your Firebase Cloud Messaging server key.

  Future<void> sendNotification(String targetToken, String title, String body) async {
    try {
      final url = Uri.parse('https://fcm.googleapis.com/fcm/send');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$_serverKey',
        },
        body: json.encode({
          'to': targetToken,
          'notification': {
            'title': title,
            'body': body,
          },
        }),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully!');
      } else {
        print('Failed to send notification. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }

  }
  void reportIssue() async {
    NotificationServices notificationServices = NotificationServices();

    // Replace with target device token
    String targetToken = "TARGET_DEVICE_TOKEN"; // Get this dynamically if needed

    await notificationServices.sendNotification(
        targetToken,
        "New Report Submitted",
        "A new report has been submitted. Tap to view."
    );
  }
}

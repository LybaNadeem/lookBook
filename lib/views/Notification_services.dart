import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/Notification_model.dart';
import 'package:googleapis_auth/auth_io.dart' as google_auth;




class NotificationServices  {
  // Firebase and Local Notification instances
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // State variables
  List<NotificationModel> _notifications = [];
  int _unreadCount = 0;


  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _unreadCount;

  Future<bool> isFirstLogin(String userId) async {
    // You can use Firestore to check if the user has logged in before
    var doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists) {
      // Mark as first login by saving a flag in Firestore or SharedPreferences
      await _firestore.collection('users').doc(userId).set({
        'firstLogin': true,
        'deviceToken': await getDeviceToken(),
      });
      return true;
    }
    return false;
  }
  Future<void> handleFirstLogin() async {
    final userId = auth.currentUser?.uid;
    if (userId != null) {
      bool isFirstTime = await isFirstLogin(userId);
      if (isFirstTime) {
        await requestNotificationPermission();  // Request permission on first login
      }
    }
  }
  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Handle successful permission
      print('Notification permission granted!');
    } else {
      // Handle failed permission
      print('Notification permission denied!');
    }
  }
  // Future<void> requestNotificationPermission() async {
  //   NotificationSettings settings = await _messaging.requestPermission(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );
  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //
  //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //       // Handle foreground notifications
  //       print('Message received: ${message.notification?.body}');
  //       // Show a local notification if needed
  //     });
  //
  //     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //       // Handle when the app is opened from a notification
  //       print('Notification clicked!');
  //     });
  //   }
  //
  // }

  void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
    InitializationSettings(android: androidInitializationSettings);
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification tap
        handleMessage(context, message);
      },
    );
  }
  Future<String> getAccessToken() async {
    try {
      final credentials =
      google_auth.ServiceAccountCredentials.fromJson(serviceAccountJson);

      final List<String> scopes = [
        'https://www.googleapis.com/auth/firebase.messaging',
        'https://www.googleapis.com/auth/cloud-platform',
      ];

      // Get OAuth2 client
      final google_auth.AutoRefreshingAuthClient client =
      await google_auth.clientViaServiceAccount(credentials, scopes);

      // Obtain the access token
      final accessToken = client.credentials.accessToken.data;

      print('Access Token: $accessToken');
      return accessToken;
    } catch (e) {
      print('Error obtaining access token: $e');
      rethrow;
    }
  }
  Future<void> sendPushNotification(
      String name,
      String token,
      String msg,
      String receiverId,
      String type,
      String? ChatroomId,
      String? productId,
      ) async
  {
    try {
      final String accessToken = await getAccessToken();

      // Firebase FCM v1 URL for your project
      final String fcmUrl =
          'https://fcm.googleapis.com/v1/projects/designer-model/messages:send';

      final body = {
        'message': {
          'token': token,
          'notification': {
            'title': name,
            'body': msg,
          },
          'data': {
            'id': auth.currentUser?.uid ?? '',
            'targetId': receiverId,
            'senderId': auth.currentUser?.uid ?? '',
            'type': type,
            'chatroomId': ChatroomId ?? '',
          },
        },
      };

      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Notification sent successfully

        print('Notification sent: ${response.body}');
      } else {
        // Handle unsuccessful response
        print(
            'Failed to send notification. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending push notification: $e');
    }
  }
  // Show Local Notification
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(10000).toString(),
      'Channel Name',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        channel.id.toString(), channel.name.toString(),
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        ticker: 'ticker');
    NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  // Fetch Notifications from Firestore
  Future<void> fetchNotifications() async {
    final String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) return;

    QuerySnapshot snapshot = await _firestore
        .collection('Notifications')
        .where('receiverId', isEqualTo: userId)
        .orderBy('time', descending: true)
        .get();

    _notifications = snapshot.docs
        .map((doc) => NotificationModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    _unreadCount = _notifications.where((n) => !n.isRead).length;


  }

  // Update Notification Read Status
  Future<void> updateNotificationStatus(String notificationId, bool isRead) async {
    await _firestore.collection('Notifications').doc(notificationId).update({
      'isRead': isRead,
    });

    // Update local state
    _notifications = _notifications.map((notification) {
      if (notification.id == notificationId) {
        notification.isRead = isRead;
      }
      return notification;
    }).toList();
    _unreadCount = _notifications.where((n) => !n.isRead).length;


  }

  // Firebase Messaging Initialization
  void initFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Message received: ${message.notification?.body}");
      showNotification(message); // Show local notification
      fetchNotifications(); // Refresh notifications
    });
  }
  // final serviceAccountJson = {
  //   "type": "service_account",
  //   "project_id": "designer-model",
  //   "private_key_id": "1a88bfa4360ce24cf0d6c31dd76b49bc51573b9b",
  //   "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDChZgmDvRRtn/b\nVUavZJ0wqIOtfuzoDJCYzqMHH3g7JVLW4ZjLdUAkWOOZQQy0J6S8p4vD07FY2EPI\nLMhK0R5YIi39l1iSa6oi0edTYEjLBooPcK2h2+2fi7r2rx0nQF+KpZG3ijct1/oW\n45B7a0MZeO9eMVJNuC4LEz03ABjj1bEfrKw49m8go0DAhJctpderEt8BMHZPYlh/\nTYlXQbhFzUcHfwGwfZHVoXcORXZPsyS4sUWMM5L3mWHRojawClQurzAGbBjkS7MM\nVw/Xi4oM1PgQQ5CifwCJyjmp+lej9p7vHnuP8a3qCeTxGmm78pM07mBbSTEx6AJ6\nDgiGpGKBAgMBAAECggEAMBnEao7Sm/0epzAyWy8sToqxCv8immv2+o5IUnvV6Xw8\nfI3LEG6VNpezaiNjfo36BruAjGNFzLQnqLFoMtX8pKsJB9b7rDNK3jLc+qlJvsiG\nbbR9fxOI8iWljRf2w8y/g2OXQZVAOUoZmbzabqZysHMO79IO6dCENDFk9vuDbBzt\ndws1tD7aB/ARn89sGuiLEKDDsvXGwayGo77D1xPieVZ4U+oeloGv86ZB7r/CrQrp\nSy/GUdYoEmNOq/zd+3Snvp0WtN3a7GRo4NiOvN5KSLfLogqOiEKNzqqovNympk0G\n6gv1oIm/ulNWDvALAApOWErph+YOjFaKBp1m8cA+1QKBgQD7qbrkGyDvVwr0u6Iu\n+syD/kMwnFaS6I7gkeeGn6DSYkgpwPG56/46G9noWoImteGYQPmvgvT+EzQY9mIf\nyFJWjXdJOH0ycDo5BBaM/x11RKFFZKckR9aW+mrD0R4+7N8rDpiurrPVwdQ2zdZb\n/QJKYvfawNu2fkBAvS33jHzzRQKBgQDF38XUtxom49gBNQE+bCxkIPPVx6Yncor4\nwiDg1OF4hwrF35W2Pa3AJUIQk3SOjvPv5kIwCbf/a+s4pvA8n3o81i8V+HolHJeC\nQB5daHUbvo+HBrVilS0MtOEOLAYq18XEgs5KE/KQbSFhD3+X0iqcu0ZNgvXEf5x0\nzv/VNxhoDQKBgDCaYhbFyoGOzPXg+vyZwT/Irk9IEkxDD7z9ULqmP5gCFS/DLKwc\nkLfGQzplqHczb0NJYS9tWkVrjgc4JlE/De/bWGtStpM0K3pxeK14Y8cPHxpYyxLt\nsNrtuArjazT56EvXgNNTuDWTPpnq/Pg9D+Ev5fBgiM5g6aXXI3aIsmUFAoGAFz1F\nzcrHboPZ7aJdCAjKWeQo3xW4pO9l9PtPwzgdVvt9P2oX+jRaQLPfg3Td/pQ5gBZp\n9ZxemMgC8z9f/a65O4XoN8tcBRnLjYecSVooTt7dmn0mNnLQvKpNuE1hWAzJdF/s\nfHTFS0MV5YFdeeY8DPZNtnLIDJD0Ph/FmjQDUM0CgYEAjDSifEbCeXv3N7gRlBTa\nX3QC6ZZhdQ8mOK3v/Fwj2WuAS29s7DMj5KkwrH/DcW06M7/A3fNAMY5aga924QSl\nsGY/Nt21/32IRu/eZTQ7Yo2ZdCjiWjLycXMYxsjFZzEVyNi5Og/IYqYkpyvVmg+r\nwW2wzBtGQEhAK+YgKiILsrU=\n-----END PRIVATE KEY-----\n",
  //   "client_email": "notification-lookbook@designer-model.iam.gserviceaccount.com",
  //   "client_id": "104473875555006306688",
  //   "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  //   "token_uri": "https://oauth2.googleapis.com/token",
  //   "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  //   "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/notification-lookbook%40designer-model.iam.gserviceaccount.com",
  //   "universe_domain": "googleapis.com"
  // };
  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'msj') {

    }
  }
  Future<String> getDeviceToken() async {
    String? token = await _messaging.getToken();
    return token ?? '';
  }

  void isTokenRefresh() async {
    _messaging.onTokenRefresh.listen((event) {
      if (kDebugMode) {
        print('Token refreshed: $event');
      }
    });
  }
  // Get FCM Token
  Future<String?> getFCMToken() async {
    return await _messaging.getToken();
  }
  Future<String?> getAdminDeviceToken() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'admin') // Fetch the admin user(s)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first['deviceToken']; // Assume the first admin in case of multiple
    }
    return null; // Return null if no admin found
  }

}


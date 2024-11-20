import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  String? notificationMessage;

  void updateNotification(String message) {
    notificationMessage = message;
    notifyListeners(); // Notifies all listeners of the state change
  }
}

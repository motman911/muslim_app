import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseMessagingService {
  void setupForegroundHandlers() {
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('FCM foreground: ${message.messageId}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('FCM opened app: ${message.messageId}');
    });
  }
}

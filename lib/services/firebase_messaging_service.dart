import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseMessagingService {
  static final StreamController<String> _routeController =
      StreamController<String>.broadcast();
  static bool _initialized = false;

  Stream<String> get deepLinkRouteStream => _routeController.stream;

  void setupForegroundHandlers() {
    if (_initialized) {
      return;
    }
    _initialized = true;

    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('FCM foreground: ${message.messageId}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('FCM opened app: ${message.messageId}');
      final route = _resolveRoute(message.data);
      if (route != null) {
        _routeController.add(route);
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message == null) {
        return;
      }

      final route = _resolveRoute(message.data);
      if (route != null) {
        _routeController.add(route);
      }
    });
  }

  String? _resolveRoute(Map<String, dynamic> data) {
    final directRoute = data['route']?.toString();
    if (directRoute != null && directRoute.startsWith('/')) {
      return directRoute;
    }

    final type = data['type']?.toString();
    switch (type) {
      case 'open_bookmarks':
        return '/bookmarks';
      case 'group_join':
      case 'group_message':
      case 'achievement':
      case 'weekly_challenge':
      case 'daily_ayah':
      case 'inactivity_reminder':
        return '/quran';
      default:
        return null;
    }
  }
}

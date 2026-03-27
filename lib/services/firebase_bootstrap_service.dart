import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseBootstrapResult {
  const FirebaseBootstrapResult({
    required this.isReady,
    this.errorMessage,
    this.deviceId,
  });

  final bool isReady;
  final String? errorMessage;
  final String? deviceId;
}

class FirebaseBootstrapService {
  static const _deviceIdStorageKey = 'noor_device_installation_id';

  Future<FirebaseBootstrapResult> initialize(SharedPreferences prefs) async {
    final deviceId = _resolveDeviceId(prefs);

    try {
      await Firebase.initializeApp();

      final auth = FirebaseAuth.instance;
      if (auth.currentUser == null) {
        await auth.signInAnonymously();
      }

      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission();
      final token = await messaging.getToken();

      final uid = auth.currentUser?.uid;
      if (uid != null && token != null) {
        await _upsertToken(uid: uid, token: token, deviceId: deviceId);
      }

      return FirebaseBootstrapResult(
        isReady: true,
        deviceId: deviceId,
      );
    } catch (e) {
      return FirebaseBootstrapResult(
        isReady: false,
        errorMessage: e.toString(),
        deviceId: deviceId,
      );
    }
  }

  String _resolveDeviceId(SharedPreferences prefs) {
    final existing = prefs.getString(_deviceIdStorageKey);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    final generated =
        '${defaultTargetPlatform.name}-${DateTime.now().microsecondsSinceEpoch}';
    prefs.setString(_deviceIdStorageKey, generated);
    return generated;
  }

  Future<void> _upsertToken({
    required String uid,
    required String token,
    required String deviceId,
  }) async {
    final now = FieldValue.serverTimestamp();

    await FirebaseFirestore.instance.collection('fcm_tokens').doc(uid).set({
      'tokens': {deviceId: token},
      'platform': {deviceId: defaultTargetPlatform.name},
      'updatedAt': now,
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'fcmTokens': FieldValue.arrayUnion([token]),
      'lastSeen': now,
    }, SetOptions(merge: true));
  }
}

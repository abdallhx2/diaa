import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:edu_smart_assistant/services/api_service.dart';

// Top-level handler required by FCM for background messages.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // No UI available in background — just log.
  debugPrint('FCM background: ${message.messageId}');
}

class FcmService {
  FcmService._();
  static final FcmService instance = FcmService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final ApiService _api = ApiService();

  /// Call once after Firebase.initializeApp(), before runApp().
  static void registerBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// Call after parent login is confirmed.
  Future<void> initForParent() async {
    await _requestPermission();
    await _registerToken();
    _listenTokenRefresh();
    _listenForegroundMessages();
    _listenOpenedApp();
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('FCM permission: ${settings.authorizationStatus}');
  }

  Future<void> _registerToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _postToken(token);
      }
    } catch (e) {
      debugPrint('FCM token registration failed: $e');
    }
  }

  void _listenTokenRefresh() {
    _messaging.onTokenRefresh.listen((newToken) async {
      try {
        await _postToken(newToken);
      } catch (e) {
        debugPrint('FCM token refresh failed: $e');
      }
    });
  }

  void _listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint(
          'FCM foreground: ${message.notification?.title} — ${message.notification?.body}');
      // Foreground notifications are shown via the OS on Android 13+.
      // No additional handling needed for this release.
    });
  }

  void _listenOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('FCM app opened from notification: ${message.data}');
      // Navigation on tap can be wired here when needed.
    });
  }

  Future<void> _postToken(String token) async {
    await _api.post('/auth/fcm-token', data: {
      'token': token,
      'platform': 'android',
    });
    debugPrint('FCM token registered');
  }
}

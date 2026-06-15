import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import '../core/supabase_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: const FirebaseOptions(
    apiKey: "AIzaSyAzRGMSzkJ85Oa6gxw9PId-DkuRyQOyTh0",
    authDomain: "fluentydz.firebaseapp.com",
    projectId: "fluentydz",
    storageBucket: "fluentydz.firebasestorage.app",
    messagingSenderId: "416381337314",
    appId: "1:416381337314:web:8c7166fe13a5ad5331a8bb",
  ));
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'fluentydz_channel',
    'FluentyDZ Notifications',
    description: 'Notifications for likes, comments and reminders',
    importance: Importance.high,
  );

  static Future<void> initialize() async {
    // Request permission
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Local notifications setup (Android only — web uses browser)
    if (!kIsWeb) {
        await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);

      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initSettings =
          InitializationSettings(android: androidSettings);
      await _localNotifications.initialize(initSettings);
    }

    // Background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Foreground handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null && !kIsWeb) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channel.id,
              _channel.name,
              channelDescription: _channel.description,
              importance: Importance.high,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });

    // Save FCM token to Supabase
    await _saveFcmToken();

    // Listen for token refresh
    messaging.onTokenRefresh.listen((newToken) async {
      await SupabaseService.saveFcmToken(newToken);
    });
  }

  static Future<void> _saveFcmToken() async {
    try {
      String? token;
      if (kIsWeb) {
        token = await FirebaseMessaging.instance.getToken(
          vapidKey: 'BOJ0h9Ys77Xf5IO5-tOxnvQQ3wt7uDlZnaGiElDZDaK-rG1e6ow_VWDmTo9JyQz9CcL0VNjPIgysaufociLLacw',
        );
      } else {
        token = await FirebaseMessaging.instance.getToken();
      }
      if (token != null) {
        await SupabaseService.saveFcmToken(token);
      }
    } catch (e) {
      debugPrint('FCM token error: $e');
    }
  }
}

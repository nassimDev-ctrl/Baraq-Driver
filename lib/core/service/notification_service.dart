import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:drever_warr/core/service/api_service.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  ApiService? _apiService;
  bool _initialized = false;

  StreamSubscription<String>? _tokenRefreshSub;
  StreamSubscription<RemoteMessage>? _onMessageSub;
  StreamSubscription<RemoteMessage>? _onMessageOpenedSub;

  void setApiService(ApiService service) {
    _apiService = service;
  }

  static Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
    // You can handle background messages here if needed.
  }

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null && details.payload!.isNotEmpty) {
          try {
            jsonDecode(details.payload!);
            // Handle tap action here if needed.
          } catch (_) {
            // Ignore invalid payloads.
          }
        }
      },
    );

    await syncToken();

    _tokenRefreshSub?.cancel();
    _tokenRefreshSub = FirebaseMessaging.instance.onTokenRefresh.listen(
          (newToken) async {
        await _updateFcmToken(newToken);
      },
    );

    _onMessageSub?.cancel();
    _onMessageSub = FirebaseMessaging.onMessage.listen((message) {
      _showLocalNotification(message);
    });

    _onMessageOpenedSub?.cancel();
    _onMessageOpenedSub = FirebaseMessaging.onMessageOpenedApp.listen(
          (message) {
        // Handle notification tap from background if needed.
      },
    );
  }

  Future<void> syncToken() async {
    final api = _apiService;
    if (api == null) return;

    final token = await _messaging.getToken();
    if (token != null && token.isNotEmpty) {
      await _updateFcmToken(token);
    }
  }

  Future<void> clearToken() async {
    final api = _apiService;
    if (api == null) return;

    try {
      await api.put(
        endPoint: '/auth-users/update-fcm',
        data: {'fcm': ''},
        isfromdata: false,
      );
    } catch (e) {
      AppLogger.error('FCM clear error: $e', error: e);
    }
  }

  Future<void> _updateFcmToken(String token) async {
    final api = _apiService;
    if (api == null) return;

    try {
      await api.put(
        endPoint: '/auth-users/update-fcm',
        data: {
          'fcm': token,
        },
        isfromdata: false,
      );
    } catch (e) {
      AppLogger.error('FCM update error: $e', error: e);
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Notifications',
      channelDescription: 'General notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(
      id : message.hashCode,
      title : message.notification?.title ?? "Notification",
      body : message.notification?.body ?? '',
      notificationDetails: notificationDetails,
      payload: jsonEncode(message.data),
    );
  }

  Future<void> dispose() async {
    await _tokenRefreshSub?.cancel();
    await _onMessageSub?.cancel();
    await _onMessageOpenedSub?.cancel();
    _tokenRefreshSub = null;
    _onMessageSub = null;
    _onMessageOpenedSub = null;
    _initialized = false;
  }
}
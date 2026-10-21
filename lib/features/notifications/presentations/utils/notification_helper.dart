import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Background message: ${message.messageId}');
}

class NotificationHelper {
  static final NotificationHelper _instance = NotificationHelper._internal();
  factory NotificationHelper() => _instance;
  NotificationHelper._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();

  // App-lifetime broadcast streams. Never closed: this is a singleton.
  final _onMessageController = StreamController<RemoteMessage>.broadcast();
  final _onMessageOpenedAppController = StreamController<RemoteMessage>.broadcast();
  final _onNotificationTapController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<RemoteMessage> get onMessageStream => _onMessageController.stream;
  Stream<RemoteMessage> get onMessageOpenedAppStream => _onMessageOpenedAppController.stream;
  Stream<Map<String, dynamic>> get onNotificationTapStream => _onNotificationTapController.stream;

  final List<StreamSubscription<dynamic>> _subscriptions = [];

  bool _isInitialized = false;
  Future<void>? _initFuture;

  String _channelId = 'high_importance_channel';
  String _channelName = 'High Importance Notifications';
  String _channelDescription = 'This channel is used for important notifications.';

  Map<String, dynamic>? _launchData;
  Map<String, dynamic>? takeLaunchData() {
    final data = _launchData;
    _launchData = null;
    return data;
  }

  bool get _isAndroid => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  bool get _isApple =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  // ---------------------------------------------------------------------------
  // Init
  // ---------------------------------------------------------------------------

  Future<void> initialize({
    String? channelId,
    String? channelName,
    String? channelDescription,
    String? icon,
    FutureOr<void> Function(String token)? onTokenChanged,
  }) {
    if (_isInitialized) return Future.value();
    return _initFuture ??= _initialize(
      channelId: channelId,
      channelName: channelName,
      channelDescription: channelDescription,
      icon: icon,
      onTokenChanged: onTokenChanged,
    ).whenComplete(() => _initFuture = null);
  }

  Future<void> _initialize({
    String? channelId,
    String? channelName,
    String? channelDescription,
    String? icon,
    FutureOr<void> Function(String token)? onTokenChanged,
  }) async {
    try {
      _channelId = channelId ?? _channelId;
      _channelName = channelName ?? _channelName;
      _channelDescription = channelDescription ?? _channelDescription;

      await _requestPermissions();
      await _initializeLocalNotifications(icon: icon);
      await _setupFirebaseMessaging(onTokenChanged);

      _isInitialized = true;
      log('NotificationHelper initialized');
    } catch (e, st) {
      // _isInitialized stays false, so a later initialize() call can retry.
      log('Error initializing NotificationHelper: $e', stackTrace: st);
    }
  }

  Future<bool> _requestPermissions() async {
    try {
      final settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      log('Notification permission: ${settings.authorizationStatus}');
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      log('Error requesting notification permissions: $e');
      return false;
    }
  }

  Future<void> _initializeLocalNotifications({String? icon}) async {
    final settings = InitializationSettings(
      android: AndroidInitializationSettings(icon ?? '@mipmap/ic_launcher'),
      // Permissions are already requested via FCM above. Asking again here
      // would just be redundant.
      iOS: const DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    // v20+: named parameters.
    await _local.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    await _local
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: _channelDescription,
            importance: Importance.max,
            playSound: true,
            enableVibration: true,
            showBadge: true,
          ),
        );

    // App launched by tapping a LOCAL notification while terminated.
    final launch = await _local.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) {
      _launchData ??= _decodePayload(launch?.notificationResponse?.payload);
    }
  }

  Future<void> _setupFirebaseMessaging(
    FutureOr<void> Function(String token)? onTokenChanged,
  ) async {
    // Token
    final token = await _fetchToken();
    log('FCM token: $token');
    if (token != null && token.isNotEmpty) {
      await onTokenChanged?.call(token);
    }

    _subscriptions.add(
      _fcm.onRegistered.listen((newToken) async {
        log('FCM token refreshed: $newToken');
        if (newToken.isNotEmpty) await onTokenChanged?.call(newToken);
      }, onError: (Object e) => log('Token refresh error: $e')),
    );

    await _fcm.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

    _subscriptions.add(
      FirebaseMessaging.onMessage.listen((message) {
        log('Foreground message: ${message.messageId}');
        _onMessageController.add(message);
        if (_isAndroid) _showLocalNotification(message);
      }),
    );

    _subscriptions.add(
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        log('Opened from notification: ${message.messageId}');
        _onMessageOpenedAppController.add(message);
        _onNotificationTapController.add(Map<String, dynamic>.from(message.data));
      }),
    );

    // Terminated state (FCM). Stored, not streamed. See takeLaunchData().
    final initial = await _fcm.getInitialMessage();
    if (initial != null) {
      log('Launched from terminated state: ${initial.messageId}');
      _launchData = Map<String, dynamic>.from(initial.data);
    }
  }

  Future<String?> _fetchToken() async {
    try {
      if (_isApple) {
        String? apns = await _fcm.getAPNSToken();
        for (var i = 0; apns == null && i < 5; i++) {
          await Future<void>.delayed(const Duration(seconds: 1));
          apns = await _fcm.getAPNSToken();
        }
        if (apns == null) {
          log('APNs token not available yet (simulator, or missing capability/key?)');
          return null;
        }
      }
      return await _fcm.getToken();
    } catch (e) {
      log('Error getting FCM token: $e');
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Local notifications
  // ---------------------------------------------------------------------------

  NotificationDetails get _details => NotificationDetails(
    android: AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    ),
    iOS: const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final id = (message.messageId?.hashCode ?? DateTime.now().millisecondsSinceEpoch) & 0x7FFFFFFF;

    try {
      await _local.show(
        id: id,
        title: notification.title,
        body: notification.body,
        notificationDetails: _details,
        payload: jsonEncode(message.data),
      );
    } catch (e) {
      log('Error showing local notification: $e');
    }
  }

  Future<void> showCustomNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    try {
      await _local.show(
        id: DateTime.now().millisecondsSinceEpoch & 0x7FFFFFFF,
        title: title,
        body: body,
        notificationDetails: _details,
        payload: jsonEncode(payload ?? {}),
      );
    } catch (e) {
      log('Error showing custom notification: $e');
    }
  }
  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    log('Local notification tapped: ${response.payload}');
    final data = _decodePayload(response.payload);
    if (data != null) _onNotificationTapController.add(data);
  }

  Map<String, dynamic>? _decodePayload(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (e) {
      log('Invalid notification payload: $e');
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Topics / token / misc
  // ---------------------------------------------------------------------------

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _fcm.subscribeToTopic(topic);
      log('Subscribed to topic: $topic');
    } catch (e) {
      log('Error subscribing to topic $topic: $e');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _fcm.unsubscribeFromTopic(topic);
      log('Unsubscribed from topic: $topic');
    } catch (e) {
      log('Error unsubscribing from topic $topic: $e');
    }
  }

  Future<String?> getFCMToken() => _fetchToken();
  Future<void> deleteToken() async {
    try {
      await _fcm.unregister();
    } catch (e) {
      log('Error deleting FCM token: $e');
    }
  }

  Future<void> clearAllNotifications() => _local.cancelAll();
  Future<void> dispose() async {
    for (final s in _subscriptions) {
      await s.cancel();
    }
    _subscriptions.clear();
    _isInitialized = false;
  }
}

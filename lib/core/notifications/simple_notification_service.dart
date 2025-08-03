import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'notification_manager.dart';

class SimpleNotificationService {
  static final SimpleNotificationService _instance = SimpleNotificationService._internal();
  factory SimpleNotificationService() => _instance;
  SimpleNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
    
    // Request notification permissions
    await requestNotificationPermissions();
    
    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'hready_channel',
      'HReady Notifications',
      description: 'Notifications from HReady app',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> requestNotificationPermissions() async {
    // Request notification permission
    final status = await Permission.notification.request();
    debugPrint('Notification permission status: $status');
    
    // For iOS, also request through the plugin
    await _notifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> showNotification({
    required String title,
    required String message,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'hready_channel',
      'HReady Notifications',
      channelDescription: 'Notifications from HReady app',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      icon: '@mipmap/ic_launcher',
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      message,
      platformDetails,
      payload: payload,
    );
    
    // Increment notification count for badge
    notificationManager.incrementCount();
  }

  Future<void> showSuccessNotification(String message) async {
    await showNotification(
      title: '✅ Success',
      message: message,
    );
  }

  Future<void> showErrorNotification(String message) async {
    await showNotification(
      title: '❌ Error',
      message: message,
    );
  }

  Future<void> showInfoNotification(String title, String message) async {
    await showNotification(
      title: title,
      message: message,
    );
  }

  Future<void> showTaskNotification(String taskTitle) async {
    await showNotification(
      title: '📋 New Task',
      message: 'You have been assigned: $taskTitle',
    );
  }

  Future<void> showLeaveNotification(String status) async {
    await showNotification(
      title: '🏖️ Leave Update',
      message: 'Your leave request has been $status',
    );
  }

  Future<void> showAttendanceNotification(String message) async {
    await showNotification(
      title: '📅 Attendance',
      message: message,
    );
  }

  Future<void> showAnnouncementNotification(String title) async {
    await showNotification(
      title: '📢 Announcement',
      message: 'New announcement: $title',
    );
  }

  Future<void> showPayrollNotification(String message) async {
    await showNotification(
      title: '💰 Payroll',
      message: message,
    );
  }

  Future<void> clearAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<void> setAppBadgeCount(int count) async {
    // Set badge count for iOS
    await _notifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    
    // For Android, we can use the notification count
    // iOS will automatically show the badge count
    debugPrint('Setting app badge count to: $count');
  }

  Future<void> clearAppBadge() async {
    await setAppBadgeCount(0);
  }
}

// Global instance
final simpleNotificationService = SimpleNotificationService(); 
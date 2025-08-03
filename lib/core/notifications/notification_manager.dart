import 'dart:async';
import 'package:flutter/foundation.dart';
import 'simple_notification_service.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;
  NotificationManager._internal();

  final StreamController<int> _notificationCountController = StreamController<int>.broadcast();
  Stream<int> get notificationCountStream => _notificationCountController.stream;

  int _notificationCount = 0;
  int get notificationCount => _notificationCount;

  void incrementCount() {
    _notificationCount++;
    _notificationCountController.add(_notificationCount);
    _updateAppBadge();
    debugPrint('Notification count: $_notificationCount');
  }

  void decrementCount() {
    if (_notificationCount > 0) {
      _notificationCount--;
      _notificationCountController.add(_notificationCount);
      _updateAppBadge();
    }
  }

  void resetCount() {
    _notificationCount = 0;
    _notificationCountController.add(_notificationCount);
    _updateAppBadge();
  }

  void _updateAppBadge() {
    simpleNotificationService.setAppBadgeCount(_notificationCount);
  }

  void dispose() {
    _notificationCountController.close();
  }
}

final notificationManager = NotificationManager(); 
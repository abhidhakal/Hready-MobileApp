import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hready/app/app.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:hready/core/notifications/simple_notification_service.dart';
import 'package:hready/features/auth/data/models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for Flutter
  await Hive.initFlutter();

  // Register Hive adapter
  Hive.registerAdapter(UserHiveModelAdapter());

  // Setup Dependency Injection
  await setupLocator();

  // Initialize Notification Service
  await simpleNotificationService.initialize();

  runApp(const App());
}

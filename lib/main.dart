import 'package:flutter/material.dart';
import 'package:hready/app/app.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:hready/core/network/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();

  // initialize Hive from HiveService
  await getIt<HiveService>().init();

  runApp(const App());
}

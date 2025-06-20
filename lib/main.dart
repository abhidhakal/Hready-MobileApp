import 'package:flutter/material.dart';
import 'package:hready/app/app.dart';
import 'package:hready/app/service_locator/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator(); // Register dependencies

  runApp(const App());
}
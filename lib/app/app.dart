import 'package:flutter/material.dart';
import 'package:hready/features/splash/splash_screen.dart';
import 'package:hready/app/theme/hready_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: getApplicationTheme(),title: 'HReady', debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}
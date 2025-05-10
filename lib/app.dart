import 'package:flutter/material.dart';
import 'package:hready/view/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'HReady', debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}
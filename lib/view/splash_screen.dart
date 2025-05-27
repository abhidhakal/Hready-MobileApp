import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:hready/view/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver {
  bool hasRunSplash = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startSplash();
  }

  void _startSplash() {
    // Run splash screen only once per fresh app start
    if (!hasRunSplash) {
      hasRunSplash = true;
      Timer(const Duration(milliseconds: 2400), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const Login()),
          );
        }
      });
    } else {
      // If resumed from background, skip splash
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const Login()),
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Optional: track app resume/paused states if needed
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/light.png', height: 250),
            const SizedBox(height: 16),
            Lottie.asset(
              'assets/animations/loading.json',
              width: 400,
              height: 100,
              repeat: true,
              animate: true,
            ),
          ],
        ),
      ),
    );
  }
}

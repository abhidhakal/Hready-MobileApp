import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:hready/features/auth/presentation/view/login.dart';

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
  if (!hasRunSplash) {
    hasRunSplash = true;

    // Wait for first frame to complete before starting splash timer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 2400), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        }
      });
    });
  } else {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
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
            Image.asset('assets/images/light.webp', height: 250),
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

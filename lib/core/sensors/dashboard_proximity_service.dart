import 'dart:async';
import 'package:flutter/material.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:screen_brightness/screen_brightness.dart';

class DashboardProximityService {
  StreamSubscription<dynamic>? _subscription;

  void initialize({
    required VoidCallback onProximityDetected,
    required VoidCallback onProximityLost,
  }) {
    _subscription = ProximitySensor.events.listen((event) async {
      final isNear = event as bool;

      if (isNear) {
        onProximityDetected();
        // Dim the screen to 0 brightness
        await ScreenBrightness().setScreenBrightness(0.0);
      } else {
        onProximityLost();
        // Restore brightness to default
        await ScreenBrightness().resetScreenBrightness();
      }
    });
  }

  void simulateProximityDetection() async {
    await ScreenBrightness().setScreenBrightness(0.0);
    Future.delayed(const Duration(seconds: 3), () {
      ScreenBrightness().resetScreenBrightness();
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
} 
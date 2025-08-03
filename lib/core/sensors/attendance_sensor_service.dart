import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AttendanceSensorService {
  static final AttendanceSensorService _instance = AttendanceSensorService._internal();
  factory AttendanceSensorService() => _instance;
  AttendanceSensorService._internal();

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  Timer? _attendanceTimer;
  bool _isNearFace = false;
  bool _isActive = false;
  
  // Callbacks
  VoidCallback? _onAttendanceTriggered;
  VoidCallback? _onProximityDetected;
  VoidCallback? _onProximityLost;
  Function(double)? _onTimerProgress;

  // Initialize attendance sensor
  void initialize({
    required VoidCallback onAttendanceTriggered,
    VoidCallback? onProximityDetected,
    VoidCallback? onProximityLost,
    Function(double)? onTimerProgress,
    int holdDurationSeconds = 3,
  }) {
    _onAttendanceTriggered = onAttendanceTriggered;
    _onProximityDetected = onProximityDetected;
    _onProximityLost = onProximityLost;
    _onTimerProgress = onTimerProgress;
    
    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      // Detect when phone is held near face (tilted up and stable)
      bool isPhoneNearFace = _detectPhoneNearFace(event);
      bool wasNearFace = _isNearFace;
      _isNearFace = isPhoneNearFace;
      
      if (_isNearFace && !wasNearFace) {
        // Face detected
        _onProximityDetected?.call();
        _startAttendanceTimer(holdDurationSeconds);
      } else if (!_isNearFace && wasNearFace) {
        // Face lost
        _onProximityLost?.call();
        _cancelAttendanceTimer();
      }
    });
    
    _isActive = true;
  }

  bool _detectPhoneNearFace(AccelerometerEvent event) {
    // Phone is near face when:
    // 1. Z-axis is positive (phone is upright)
    // 2. Y-axis is negative (phone is tilted up)
    // 3. Movement is minimal (stable)
    return event.z > 5.0 && event.y < -2.0;
  }

  void _startAttendanceTimer(int durationSeconds) {
    _cancelAttendanceTimer();
    
    int elapsed = 0;
    _attendanceTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      elapsed += 100;
      double progress = elapsed / (durationSeconds * 1000);
      
      if (progress >= 1.0) {
        // Timer completed
        _cancelAttendanceTimer();
        _onAttendanceTriggered?.call();
      } else {
        // Update progress
        _onTimerProgress?.call(progress);
      }
    });
  }

  void _cancelAttendanceTimer() {
    _attendanceTimer?.cancel();
    _attendanceTimer = null;
  }

  bool get isNearFace => _isNearFace;
  bool get isActive => _isActive;

  void dispose() {
    _cancelAttendanceTimer();
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
    _isActive = false;
  }
} 
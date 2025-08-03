import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_bloc.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_event.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_state.dart';
import 'package:hready/core/sensors/attendance_sensor_service.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hready/core/utils/common_snackbar.dart';

class EmployeeAttendance extends StatefulWidget {
  const EmployeeAttendance({super.key});

  @override
  State<EmployeeAttendance> createState() => _EmployeeAttendanceState();
}

class _EmployeeAttendanceState extends State<EmployeeAttendance> {
  final AttendanceSensorService _sensorService = AttendanceSensorService();
  bool _isSensorActive = false;
  double _timerProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeSensor();
  }

  @override
  void dispose() {
    _sensorService.dispose();
    super.dispose();
  }

  void _initializeSensor() {
    _sensorService.initialize(
      onAttendanceTriggered: _handleAttendanceTrigger,
      onProximityDetected: () {
        setState(() {
          _isSensorActive = true;
          _timerProgress = 0.0;
        });
        showSafeCommonSnackbar(context, "Hold your head close to the camera for attendance");
      },
      onProximityLost: () {
        setState(() {
          _isSensorActive = false;
          _timerProgress = 0.0;
        });
      },
      onTimerProgress: (progress) {
        setState(() {
          _timerProgress = progress;
        });
      },
    );
  }

  void _handleAttendanceTrigger() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isSensorActive = false;
      _timerProgress = 0.0;
    });
    
    // Get current attendance state and trigger appropriate action
    final attendanceBloc = context.read<AttendanceBloc>();
    final state = attendanceBloc.state;
    
    if (state is AttendanceLoaded) {
      final todayStatus = state.todayStatus;
      if (todayStatus == 'Not Checked In' || todayStatus == 'Checked Out') {
        attendanceBloc.add(CheckIn());
        showSafeCommonSnackbar(context, "Checked in successfully!");
      } else if (todayStatus == 'Checked In') {
        attendanceBloc.add(CheckOut());
        showSafeCommonSnackbar(context, "Checked out successfully!");
      }
    }
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'present':
      case 'checked in':
        color = Colors.green;
        break;
      case 'absent':
      case 'not checked in':
        color = Colors.red;
        break;
      case 'checked out':
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(status, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    );
  }

  Widget _buildAttendanceCard(BuildContext context, dynamic attendance, String todayStatus) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF042F46),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.access_time, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Today\'s Attendance',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      _buildStatusChip(todayStatus),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: todayStatus == 'Not Checked In' || todayStatus == 'Checked Out'
                        ? () => context.read<AttendanceBloc>().add(CheckIn())
                        : null,
                    icon: const Icon(Icons.login),
                    label: const Text('Check In'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF042F46),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: todayStatus == 'Checked In'
                        ? () => context.read<AttendanceBloc>().add(CheckOut())
                        : null,
                    icon: const Icon(Icons.logout),
                    label: const Text('Check Out'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ),
              ],
            ),
            if (_isSensorActive) ...[
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.sensor_door, color: Colors.blue, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Detecting attendance...',
                          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.blue),
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: _timerProgress,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            if (attendance != null && attendance.checkInTime != null) ...[
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Check In: ${DateFormat('HH:mm').format(DateTime.parse(attendance.checkInTime))}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              if (attendance.checkOutTime != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.red, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Check Out: ${DateFormat('HH:mm').format(DateTime.parse(attendance.checkOutTime))}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        backgroundColor: const Color(0xFFF5F5F5),
        foregroundColor: Colors.black,
        centerTitle: false,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (_) => getIt<AttendanceBloc>()..add(LoadTodayAttendance()),
        child: BlocListener<AttendanceBloc, AttendanceState>(
          listener: (context, state) {
            if (state is AttendanceError) {
              showSafeCommonSnackbar(context, state.error);
            }
          },
          child: BlocBuilder<AttendanceBloc, AttendanceState>(
            builder: (context, state) {
              if (state is AttendanceLoading) {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 2,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(height: 18, width: 120, color: Colors.white),
                                        const SizedBox(height: 10),
                                        Container(height: 14, width: 80, color: Colors.white),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 4,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 2,
                                child: ListTile(
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  title: Container(height: 16, width: 100, color: Colors.white, margin: const EdgeInsets.symmetric(vertical: 4)),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(height: 12, width: 140, color: Colors.white, margin: const EdgeInsets.symmetric(vertical: 4)),
                                      Container(height: 12, width: 80, color: Colors.white, margin: const EdgeInsets.symmetric(vertical: 4)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is AttendanceLoaded) {
                final attendance = state.attendance;
                final todayStatus = state.todayStatus;
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAttendanceCard(context, attendance, todayStatus),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

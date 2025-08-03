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

class AdminAttendance extends StatefulWidget {
  const AdminAttendance({Key? key}) : super(key: key);

  @override
  State<AdminAttendance> createState() => _AdminAttendanceState();
}

class _AdminAttendanceState extends State<AdminAttendance> {
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Hold your head close to the camera for attendance"),
            duration: Duration(seconds: 2),
          ),
        );
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
    
    if (state is AdminAttendanceLoaded) {
      final todayStatus = state.todayStatus;
      if (todayStatus == 'Not Checked In') {
        attendanceBloc.add(CheckIn());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Checked in successfully!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else if (todayStatus == 'Checked In') {
        attendanceBloc.add(CheckOut());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Checked out successfully!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
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

  Widget _buildMyAttendanceCard(BuildContext context, dynamic myRecord, String todayStatus) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('My Attendance', style: Theme.of(context).textTheme.titleLarge),
                _buildStatusChip(todayStatus),
              ],
            ),
            const SizedBox(height: 12),
            myRecord != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18, color: Colors.blueGrey),
                          const SizedBox(width: 8),
                          Text(myRecord.date != null ? DateFormat('yyyy-MM-dd').format(myRecord.date!.toLocal()) : '-', style: const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.login, size: 18, color: Colors.green),
                          const SizedBox(width: 8),
                          Text('Check In: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(myRecord.checkInTime != null ? DateFormat('hh:mm a').format(myRecord.checkInTime!.toLocal()) : '-')
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.logout, size: 18, color: Colors.red),
                          const SizedBox(width: 8),
                          Text('Check Out: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(myRecord.checkOutTime != null ? DateFormat('hh:mm a').format(myRecord.checkOutTime!.toLocal()) : '-')
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.timer, size: 18, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text('Total Hours: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                          (myRecord.totalHours != null && myRecord.checkInTime != null && myRecord.checkOutTime != null)
                              ? Text(myRecord.totalHours!.toStringAsFixed(2))
                              : const Text('-'),
                        ],
                      ),
                    ],
                  )
                : Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text('No record for today.', style: TextStyle(color: Colors.grey[700]))
                    ],
                  ),
            if (_isSensorActive) ...[
              const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: todayStatus == 'Not Checked In'
                        ? () => context.read<AttendanceBloc>().add(CheckIn())
                        : null,
                    icon: const Icon(Icons.login),
                    label: const Text('Check In'),
                    style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: todayStatus == 'Checked In'
                        ? () => context.read<AttendanceBloc>().add(CheckOut())
                        : null,
                    icon: const Icon(Icons.logout),
                    label: const Text('Check Out'),
                    style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeAttendanceList(List allRecords) {
    if (allRecords.isEmpty) {
      return Center(
        child: Column(
          children: [
            const Icon(Icons.group_off, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text('No employee attendance records found.', style: TextStyle(color: Colors.grey[700], fontSize: 18)),
          ],
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: allRecords.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final record = allRecords[index];
        String employeeName = 'N/A';
        if (record.user is Map && record.user['name'] != null && record.user['name'] is String) {
          employeeName = record.user['name'] as String;
        } else if (record.user is Map && record.user['_id'] != null && record.user['_id'] is String) {
          employeeName = record.user['_id'] as String;
        } else if (record.user != null && record.user is String) {
          employeeName = record.user as String;
        }
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text(
                employeeName.isNotEmpty ? employeeName[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(employeeName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.date != null ? DateFormat('yyyy-MM-dd').format(record.date!.toLocal()) : '-', style: const TextStyle(fontSize: 13)),
                Row(
                  children: [
                    const Icon(Icons.login, size: 16, color: Colors.green),
                    const SizedBox(width: 4),
                    Text('In: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text(record.checkInTime != null ? DateFormat('hh:mm a').format(record.checkInTime!.toLocal()) : '-', style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 12),
                    const Icon(Icons.logout, size: 16, color: Colors.red),
                    const SizedBox(width: 4),
                    Text('Out: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text(record.checkOutTime != null ? DateFormat('hh:mm a').format(record.checkOutTime!.toLocal()) : '-', style: const TextStyle(fontSize: 12)),
                  ],
                ),
                Row(
                  children: [
                    _buildStatusChip(record.status ?? '-'),
                    const SizedBox(width: 12),
                    const Icon(Icons.timer, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text('Hours: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    (record.totalHours != null && record.checkInTime != null && record.checkOutTime != null)
                        ? Text(record.totalHours!.toStringAsFixed(2), style: const TextStyle(fontSize: 12))
                        : const Text('-', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AttendanceBloc>(
      create: (_) => getIt<AttendanceBloc>()..add(LoadAllAttendance()),
      child: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Attendance Management'),
              backgroundColor: const Color(0xFFF5F5F5),
              foregroundColor: Colors.black,
              centerTitle: false,
            ),
            body: SafeArea(
              child: Builder(
                builder: (context) {
                  if (state is AttendanceLoading) {
                    return Column(
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
                        ListView.separated(
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
                      ],
                    );
                  } else if (state is AttendanceError) {
                    return Center(child: Text('Error: ${state.error}'));
                  } else if (state is AdminAttendanceLoaded) {
                    final myRecord = state.myRecord;
                    final todayStatus = state.todayStatus;
                    final allRecords = state.allRecords;
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMyAttendanceCard(context, myRecord, todayStatus),
                          const SizedBox(height: 32),
                          Text('Employee Attendance Records', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 12),
                          _buildEmployeeAttendanceList(allRecords),
                        ],
                      ),
                    );
                  }
                  return const Center(child: Text('No data available.'));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

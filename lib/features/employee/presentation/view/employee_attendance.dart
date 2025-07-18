import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_bloc.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_event.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_state.dart';
import 'package:intl/intl.dart';

class EmployeeAttendance extends StatelessWidget {
  const EmployeeAttendance({super.key});

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
            attendance != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18, color: Colors.blueGrey),
                          const SizedBox(width: 8),
                          Text(attendance.date != null ? DateFormat('yyyy-MM-dd').format(attendance.date!.toLocal()) : '-', style: const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.login, size: 18, color: Colors.green),
                          const SizedBox(width: 8),
                          Text('Check In: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(attendance.checkInTime != null ? DateFormat('hh:mm a').format(attendance.checkInTime!.toLocal()) : '-')
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.logout, size: 18, color: Colors.red),
                          const SizedBox(width: 8),
                          Text('Check Out: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(attendance.checkOutTime != null ? DateFormat('hh:mm a').format(attendance.checkOutTime!.toLocal()) : '-')
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.timer, size: 18, color: Colors.black),
                          const SizedBox(width: 8),
                          Text('Total Hours: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                          (attendance.totalHours != null && attendance.checkInTime != null && attendance.checkOutTime != null)
                              ? Text(attendance.totalHours!.toStringAsFixed(2))
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AttendanceBloc>(
      create: (_) => getIt<AttendanceBloc>()..add(LoadTodayAttendance()),
      child: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          if (state is AttendanceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AttendanceError) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is AttendanceLoaded) {
            final attendance = state.attendance;
            final todayStatus = state.todayStatus;
            return Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Text('Attendance', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
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
    );
  }
}

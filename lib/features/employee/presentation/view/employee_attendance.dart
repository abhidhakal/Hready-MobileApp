import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_bloc.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_event.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_state.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hready/core/utils/common_snackbar.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        backgroundColor: const Color(0xFFF5F5F5),
        foregroundColor: Colors.black,
        centerTitle: false,
        elevation: 0,
      ),
      body: BlocProvider<AttendanceBloc>(
        create: (_) => getIt<AttendanceBloc>()..add(LoadTodayAttendance()),
        child: BlocBuilder<AttendanceBloc, AttendanceState>(
          builder: (context, state) {
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
              );
            } else if (state is AttendanceError) {
              showCommonSnackbar(context, state.error);
              return const SizedBox.shrink();
            } else if (state is AttendanceLoaded) {
              final attendance = state.attendance;
              final todayStatus = state.todayStatus;
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAttendanceCard(context, attendance, todayStatus),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

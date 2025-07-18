import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_bloc.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_event.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_state.dart';
import 'package:intl/intl.dart';

class AdminAttendance extends StatelessWidget {
  const AdminAttendance({Key? key}) : super(key: key);

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
            appBar: AppBar(title: const Text('Attendance Management')),
            body: SafeArea(
              child: Builder(
                builder: (context) {
                  if (state is AttendanceLoading) {
                    return const Center(child: CircularProgressIndicator());
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_bloc.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_event.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_state.dart';
import 'package:intl/intl.dart';

class AdminAttendance extends StatelessWidget {
  const AdminAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AttendanceBloc>(
      create: (_) => getIt<AttendanceBloc>()..add(LoadAllAttendance()),
      child: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          if (state is AttendanceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AttendanceError) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is AdminAttendanceLoaded) {
            final myRecord = state.myRecord;
            final todayStatus = state.todayStatus;
            final allRecords = state.allRecords;
            return Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Attendance', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text('Status Today: ', style: const TextStyle(fontSize: 16)),
                      Text(todayStatus, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: todayStatus == 'Not Checked In'
                                ? () => context.read<AttendanceBloc>().add(CheckIn())
                                : null,
                            child: const Text('Check In'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: todayStatus == 'Checked In'
                                ? () => context.read<AttendanceBloc>().add(CheckOut())
                                : null,
                            child: const Text('Check Out'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text('Today’s Record', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      myRecord != null
                          ? Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 2,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Table(
                                  columnWidths: const {
                                    0: IntrinsicColumnWidth(),
                                    1: FlexColumnWidth(),
                                  },
                                  children: [
                                    TableRow(children: [
                                      const Text('Date:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text(myRecord.date != null ? DateFormat('yyyy-MM-dd').format(myRecord.date!.toLocal()) : '-'),
                                    ]),
                                    TableRow(children: [
                                      const Text('Check In:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text(myRecord.checkInTime != null ? DateFormat('hh:mm a').format(myRecord.checkInTime!.toLocal()) : '-'),
                                    ]),
                                    TableRow(children: [
                                      const Text('Check Out:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text(myRecord.checkOutTime != null ? DateFormat('hh:mm a').format(myRecord.checkOutTime!.toLocal()) : '-'),
                                    ]),
                                    TableRow(children: [
                                      const Text('Status:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text(myRecord.status ?? '-'),
                                    ]),
                                    TableRow(children: [
                                      const Text('Total Hours:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      (myRecord.totalHours != null && myRecord.checkInTime != null && myRecord.checkOutTime != null)
                                          ? Text(myRecord.totalHours!.toStringAsFixed(2))
                                          : const Text('-'),
                                    ]),
                                  ],
                                ),
                              ),
                            )
                          : const Text('No record for today.'),
                      const SizedBox(height: 40),
                      Text('Employee Attendance Records', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      allRecords.isNotEmpty
                          ? Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 2,
                              color: Colors.white,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns: const [
                                    DataColumn(label: Text('Employee')),
                                    DataColumn(label: Text('Date')),
                                    DataColumn(label: Text('Check In')),
                                    DataColumn(label: Text('Check Out')),
                                    DataColumn(label: Text('Status')),
                                    DataColumn(label: Text('Total Hours')),
                                  ],
                                  rows: allRecords.isNotEmpty
                                      ? allRecords.map((record) {
                                          // Debug print for user field
                                          print('Employee record.user: ${record.user}');
                                          String employeeName = 'N/A';
                                          if (record.user is Map && record.user['name'] != null && record.user['name'] is String) {
                                            employeeName = record.user['name'] as String;
                                          } else if (record.user is Map && record.user['_id'] != null && record.user['_id'] is String) {
                                            employeeName = record.user['_id'] as String;
                                          } else if (record.user != null && record.user is String) {
                                            employeeName = record.user as String;
                                          }
                                          return DataRow(cells: [
                                            DataCell(Text(employeeName)),
                                            DataCell(Text(record.date != null ? DateFormat('yyyy-MM-dd').format(record.date!.toLocal()) : '-')),
                                            DataCell(Text(record.checkInTime != null ? DateFormat('hh:mm a').format(record.checkInTime!.toLocal()) : '-')),
                                            DataCell(Text(record.checkOutTime != null ? DateFormat('hh:mm a').format(record.checkOutTime!.toLocal()) : '-')),
                                            DataCell(Text(record.status ?? '-')),
                                            DataCell((record.totalHours != null && record.checkInTime != null && record.checkOutTime != null)
                                                ? Text(record.totalHours!.toStringAsFixed(2))
                                                : const Text('-')),
                                          ]);
                                        }).toList()
                                      : [
                                          const DataRow(cells: [
                                            DataCell(Text('-')),
                                            DataCell(Text('-')),
                                            DataCell(Text('-')),
                                            DataCell(Text('-')),
                                            DataCell(Text('-')),
                                            DataCell(Text('-')),
                                          ]),
                                        ],
                                ),
                              ),
                            )
                          : const Text('No employee attendance records found.'),
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

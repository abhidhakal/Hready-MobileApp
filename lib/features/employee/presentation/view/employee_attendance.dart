import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_bloc.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_event.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_state.dart';
import 'package:intl/intl.dart';

class EmployeeAttendance extends StatelessWidget {
  const EmployeeAttendance({super.key});

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
            // Debug print for totalHours
            print('UI displaying totalHours: ${attendance.totalHours}');
            return Scaffold(
              body: SafeArea(
                child: Padding(
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
                      Card(
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
                                Text(attendance.date != null ? DateFormat('yyyy-MM-dd').format(attendance.date!.toLocal()) : '-'),
                              ]),
                              TableRow(children: [
                                const Text('Check In:', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(attendance.checkInTime != null ? DateFormat('hh:mm a').format(attendance.checkInTime!.toLocal()) : '-'),
                              ]),
                              TableRow(children: [
                                const Text('Check Out:', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(attendance.checkOutTime != null ? DateFormat('hh:mm a').format(attendance.checkOutTime!.toLocal()) : '-'),
                              ]),
                              TableRow(children: [
                                const Text('Status:', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(attendance.status ?? '-'),
                              ]),
                            ],
                          ),
                        ),
                      ),
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

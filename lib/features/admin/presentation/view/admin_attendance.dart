import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_bloc.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_event.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_state.dart';
import 'package:hready/core/widgets/app_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hready/features/employee/presentation/view_model/employee_bloc.dart';

class AdminAttendance extends StatefulWidget {
  const AdminAttendance({Key? key}) : super(key: key);

  @override
  State<AdminAttendance> createState() => _AdminAttendanceState();
}

class _AdminAttendanceState extends State<AdminAttendance> {
  DateTime _selectedDate = DateTime.now();

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

  Widget _buildEmployeeAttendanceList(List allRecords, List users) {
    // Filter attendance records for selected date
    final selectedDateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final dateAttendanceRecords = allRecords.where((record) {
      if (record.date == null) return false;
      final recordDate = DateFormat('yyyy-MM-dd').format(record.date!);
      return recordDate == selectedDateStr;
    }).toList();

    // Create complete attendance view for all employees
    final completeAttendanceView = users.map((user) {
      // Find attendance record for this employee on selected date
      final attendanceRecord = dateAttendanceRecords.cast<dynamic>().firstWhere(
        (record) {
          // Check different ways to match employee with attendance record
          if (record.user is Map && record.user['_id'] == user.employeeId) return true;
          if (record.user is Map && record.user['employeeId'] == user.employeeId) return true;
          if (record.user == user.employeeId) return true;
          return false;
        },
        orElse: () => null,
      );

      if (attendanceRecord != null) {
        // Employee has attendance record
        String status = 'Present';
        if (attendanceRecord.checkOutTime != null) {
          status = 'Checked Out';
        } else if (attendanceRecord.checkInTime != null) {
          status = 'Checked In';
        }

        return {
          'user': user,
          'attendance': attendanceRecord,
          'status': status,
          'hasRecord': true,
        };
      } else {
        // Employee has no attendance record - absent
        return {
          'user': user,
          'attendance': null,
          'status': 'Absent',
          'hasRecord': false,
        };
      }
    }).toList();

    if (completeAttendanceView.isEmpty) {
      return Center(
        child: Column(
          children: [
            const Icon(Icons.group_off, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text('No employees found.', style: TextStyle(color: Colors.grey[700], fontSize: 18)),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: completeAttendanceView.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = completeAttendanceView[index];
        final user = item['user'];
        final attendance = item['attendance'];
        final status = item['status'];
        final hasRecord = item['hasRecord'];

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat('yyyy-MM-dd').format(_selectedDate), style: const TextStyle(fontSize: 13)),
                Row(
                  children: [
                    const Icon(Icons.login, size: 16, color: Colors.green),
                    const SizedBox(width: 4),
                    Text('In: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text(
                      hasRecord && attendance?.checkInTime != null 
                          ? DateFormat('hh:mm a').format(attendance!.checkInTime!.toLocal()) 
                          : '-', 
                      style: const TextStyle(fontSize: 12)
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.logout, size: 16, color: Colors.red),
                    const SizedBox(width: 4),
                    Text('Out: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text(
                      hasRecord && attendance?.checkOutTime != null 
                          ? DateFormat('hh:mm a').format(attendance!.checkOutTime!.toLocal()) 
                          : '-', 
                      style: const TextStyle(fontSize: 12)
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildStatusChip(status),
                    const SizedBox(width: 12),
                    const Icon(Icons.timer, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text('Hours: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text(
                      hasRecord && attendance?.totalHours != null 
                          ? attendance!.totalHours!.toStringAsFixed(2) 
                          : '-', 
                      style: const TextStyle(fontSize: 12)
                    ),
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<AttendanceBloc>(
          create: (_) => getIt<AttendanceBloc>()..add(LoadAllAttendance()),
        ),
        BlocProvider<EmployeeBloc>(
          create: (_) => getIt<EmployeeBloc>()..add(LoadEmployees()),
        ),
      ],
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
                    return BlocBuilder<EmployeeBloc, EmployeeState>(
                      builder: (context, employeeState) {
                        final users = employeeState is EmployeeLoaded ? employeeState.employees : [];
                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildMyAttendanceCard(context, myRecord, todayStatus),
                              const SizedBox(height: 32),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text('Employee Attendance Records', 
                                      style: Theme.of(context).textTheme.titleLarge,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  GestureDetector(
                                    onTap: () async {
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: _selectedDate,
                                        firstDate: DateTime(2020),
                                        lastDate: DateTime(2100),
                                      );
                                      if (picked != null) {
                                        setState(() {
                                          _selectedDate = picked;
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade400),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.calendar_today, size: 16),
                                          const SizedBox(width: 8),
                                          Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildEmployeeAttendanceList(allRecords, users),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (state is AttendanceLoaded) {
                    // Handle the case when check-in/check-out is performed
                    final myRecord = state.attendance;
                    final todayStatus = state.todayStatus;
                    return BlocBuilder<EmployeeBloc, EmployeeState>(
                      builder: (context, employeeState) {
                        final users = employeeState is EmployeeLoaded ? employeeState.employees : [];
                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildMyAttendanceCard(context, myRecord, todayStatus),
                              const SizedBox(height: 32),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text('Employee Attendance Records', 
                                      style: Theme.of(context).textTheme.titleLarge,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  GestureDetector(
                                    onTap: () async {
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: _selectedDate,
                                        firstDate: DateTime(2020),
                                        lastDate: DateTime(2100),
                                      );
                                      if (picked != null) {
                                        setState(() {
                                          _selectedDate = picked;
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade400),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.calendar_today, size: 16),
                                          const SizedBox(width: 8),
                                          Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildEmployeeAttendanceList([], users), // Empty list since we don't have all records in this state
                            ],
                          ),
                        );
                      },
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

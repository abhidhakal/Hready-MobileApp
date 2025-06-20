import 'package:flutter/material.dart';

class EmployeeAttendance extends StatelessWidget {
  const EmployeeAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    // For simplicity, a basic list of attendance dates & status
    final attendanceData = [
      {'date': '2025-05-01', 'status': 'Present'},
      {'date': '2025-05-02', 'status': 'Absent'},
      {'date': '2025-05-03', 'status': 'Present'},
      // Add more data dynamically later
    ];

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Attendance'),
      //   backgroundColor: const Color(0xFF042F46),
      // ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: attendanceData.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final item = attendanceData[index];
          return ListTile(
            leading: Icon(
              item['status'] == 'Present' ? Icons.check_circle : Icons.cancel,
              color: item['status'] == 'Present' ? Colors.green : Colors.red,
            ),
            title: Text(item['date']!),
            subtitle: Text(item['status']!),
          );
        },
      ),
    );
  }
}

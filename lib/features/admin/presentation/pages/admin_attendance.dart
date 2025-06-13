import 'package:flutter/material.dart';

class AdminAttendance extends StatelessWidget {
  const AdminAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Attendance Records',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

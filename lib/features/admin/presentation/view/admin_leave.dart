import 'package:flutter/material.dart';

class AdminLeave extends StatelessWidget {
  const AdminLeave({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(
          'Leave Requests',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

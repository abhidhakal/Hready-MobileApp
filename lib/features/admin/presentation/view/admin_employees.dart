import 'package:flutter/material.dart';

class AdminEmployees extends StatelessWidget {
  const AdminEmployees({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Employees Management',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

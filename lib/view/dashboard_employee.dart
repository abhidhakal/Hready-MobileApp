import 'package:flutter/material.dart';

class DashboardEmployee extends StatefulWidget {
  const DashboardEmployee({super.key});

  @override
  State<DashboardEmployee> createState() => _DashboardEmployeeState();
}

class _DashboardEmployeeState extends State<DashboardEmployee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f5f5),
      appBar: AppBar(
        title: const Text("Employee Dashboard"),
        backgroundColor: Color(0xFF042F46),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                text: "Welcome to your Dashboard",
                style: TextStyle(
                  color: Colors.black26,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
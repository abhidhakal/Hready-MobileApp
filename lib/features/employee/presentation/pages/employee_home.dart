import 'package:flutter/material.dart';
import 'package:hready/features/auth/presentation/pages/login.dart';

class EmployeeHome extends StatelessWidget {
  const EmployeeHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Login()),
            (route) => false,
          );
        },
        child: Text("Logout"),
      ),
    );
  }
}

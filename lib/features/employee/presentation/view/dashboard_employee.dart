import 'package:flutter/material.dart';
import 'package:hready/features/employee/presentation/view/employee_announcements.dart';
import 'package:hready/features/employee/presentation/view/employee_attendance.dart';
import 'package:hready/features/employee/presentation/view/employee_leave.dart';
import 'package:hready/features/employee/presentation/view/employee_home.dart';
import 'package:hready/features/employee/presentation/view/employee_tasks.dart';
import 'package:hready/features/employee/presentation/view/employee_requests.dart';
import 'package:shake/shake.dart';
import 'package:flutter/services.dart';

class DashboardEmployee extends StatefulWidget {
  const DashboardEmployee({super.key});

  @override
  State<DashboardEmployee> createState() => _DashboardEmployeeState();
}

class _DashboardEmployeeState extends State<DashboardEmployee> {
  ShakeDetector? detector;

  static final List<Widget> _pages = [
    const EmployeeHome(),
    const EmployeeLeave(),
    const EmployeeAttendance(),
    const EmployeeTasks(),
    const EmployeeAnnouncements(),
  ];

  @override
  void initState() {
    super.initState();
    detector = ShakeDetector.autoStart(
      shakeThresholdGravity: 4.0, // Increase threshold for harder shake
      onPhoneShake: (event) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const EmployeeRequestsPage()),
        );
      },
    );
  }

  @override
  void dispose() {
    detector?.stopListening();
    super.dispose();
  }

  Widget buildNavItem(BuildContext context, IconData icon, String label, int index, int selectedIndex) {
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: selectedIndex == index ? const Color(0xFF042F46) : Colors.grey),
          Text(
            label,
            style: TextStyle(
              color: selectedIndex == index ? const Color(0xFF042F46) : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(child: _pages[_selectedIndex]),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: 70,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: BottomAppBar(
              color: Colors.transparent,
              elevation: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildNavItem(context, Icons.home_outlined, "Home", 0, _selectedIndex),
                  buildNavItem(context, Icons.beach_access, "Leave", 1, _selectedIndex),
                  buildNavItem(context, Icons.fingerprint, "Attendance", 2, _selectedIndex),
                  buildNavItem(context, Icons.assignment_outlined, "Tasks", 3, _selectedIndex),
                  buildNavItem(context, Icons.announcement_outlined, "News", 4, _selectedIndex),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
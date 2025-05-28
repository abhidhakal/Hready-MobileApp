import 'package:flutter/material.dart';
import 'package:hready/view/pages/employee_announcements.dart';
import 'package:hready/view/pages/employee_attendance.dart';
import 'package:hready/view/pages/employee_leave.dart';
import 'package:hready/view/pages/employee_profile.dart';
import 'pages/employee_home.dart';

class DashboardEmployee extends StatefulWidget {
  const DashboardEmployee({super.key});

  @override
  State<DashboardEmployee> createState() => _DashboardEmployeeState();
}

class _DashboardEmployeeState extends State<DashboardEmployee> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const EmployeeHome(),
    const EmployeeLeave(),
    const EmployeeAttendance(),
    const EmployeeAnnouncements(),
    const EmployeeProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              color: _selectedIndex == index ? Color(0xFF042F46) : Colors.grey),
          Text(
            label,
            style: TextStyle(
              color:
                  _selectedIndex == index ? Color(0xFF042F46) : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
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
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildNavItem(Icons.home_outlined, "Home", 0),
              buildNavItem(Icons.beach_access, "Leave", 1),
              buildNavItem(Icons.fingerprint, "Attendance", 2), // New icon
              buildNavItem(Icons.announcement_outlined, "News", 3),
              buildNavItem(Icons.person_outline, "Profile", 4),
            ],
          ),
        ),
      ),
    );
  }
}

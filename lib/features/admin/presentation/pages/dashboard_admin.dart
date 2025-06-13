import 'package:flutter/material.dart';
import 'package:hready/view/login.dart';
import 'package:hready/features/admin/presentation/pages/admin_announcements.dart';
import 'package:hready/features/admin/presentation/pages/admin_attendance.dart';
import 'package:hready/features/admin/presentation/pages/admin_employees.dart';
import 'package:hready/features/admin/presentation/pages/admin_home.dart';
import 'package:hready/features/admin/presentation/pages/admin_leave.dart';
import 'package:hready/features/admin/presentation/pages/admin_profile.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AdminHome(),
    const AdminEmployees(),
    const AdminAttendance(),
    const AdminLeave(),
    const AdminAnnouncements(),
    const AdminProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.pop(context); // Close drawer after selection
    });
  }

  Widget buildDrawerItem(IconData icon, String label, int index) {
    final bool selected = _selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: selected ? Color(0xFF042F46) : Colors.grey),
      title: Text(
        label,
        style: TextStyle(
          color: selected ? Color(0xFF042F46) : Colors.grey,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: selected,
      onTap: () => _onItemTapped(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),

      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF042F46),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            buildDrawerItem(Icons.dashboard_outlined, "Dashboard", 0),
            buildDrawerItem(Icons.people_outline, "Employees", 1),
            buildDrawerItem(Icons.access_time, "Attendance", 2),
            buildDrawerItem(Icons.request_page, "Leave Requests", 3),
            buildDrawerItem(Icons.announcement_outlined, "Announcements", 4),
            buildDrawerItem(Icons.person_outline, "Profile", 5),
            Spacer(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.grey),
              title: Text(
                "Logout",
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (Route<dynamic> route) => false,
              );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}

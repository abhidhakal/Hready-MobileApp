import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/admin/presentation/view/admin_announcements.dart';
import 'package:hready/features/admin/presentation/view/admin_attendance.dart';
import 'package:hready/features/admin/presentation/view/admin_employees.dart';
import 'package:hready/features/admin/presentation/view/admin_home.dart';
import 'package:hready/features/admin/presentation/view/admin_leave.dart';
import 'package:hready/features/admin/presentation/view/admin_profile.dart';
import 'package:hready/features/admin/presentation/view/admin_tasks.dart';
import 'package:hready/features/admin/presentation/view/admin_requests.dart';
import 'package:hready/features/admin/presentation/viewmodel/admin_dashboard_event.dart';
import 'package:hready/features/admin/presentation/viewmodel/admin_dashboard_state.dart';
import 'package:hready/features/admin/presentation/viewmodel/admin_dashboard_view_model.dart';
import 'package:hready/features/auth/presentation/view/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardAdmin extends StatelessWidget {
  const DashboardAdmin({super.key});

  static final List<Widget> _pages = [
    const AdminHome(),
    const AdminEmployees(),
    const AdminAttendance(),
    const AdminTasks(),
    const AdminLeave(),
    const AdminAnnouncements(),
    const AdminRequests(),
    const AdminProfilePage(),
  ];

  Widget buildDrawerItem(BuildContext context, IconData icon, String label, int index, int selectedIndex) {
    final bool selected = selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: selected ? const Color(0xFFffffff) : Colors.grey),
      title: Text(
        label,
        style: TextStyle(
          color: selected ? const Color(0xFFffffff) : Colors.grey,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: selected,
      onTap: () {
        context.read<AdminDashboardViewModel>().add(AdminTabChanged(index));
        Navigator.pop(context); // close drawer
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminDashboardViewModel(),
      child: BlocBuilder<AdminDashboardViewModel, AdminDashboardState>(
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xFFf5f5f5),
                title: const Text('Admin Panel', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                centerTitle: false,
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              ),
              drawer: SafeArea(
                child: Drawer(
                  backgroundColor: Color(0xFF042F46),
                  child: Column(
                    children: [
                      const DrawerHeader(
                        decoration: BoxDecoration(
                          color: Color(0xFF042F46),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'HReady',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      buildDrawerItem(context, Icons.dashboard_outlined, "Dashboard", 0, state.selectedIndex),
                      buildDrawerItem(context, Icons.people_outline, "Employees", 1, state.selectedIndex),
                      buildDrawerItem(context, Icons.access_time, "Attendance", 2, state.selectedIndex),
                      buildDrawerItem(context, Icons.assignment, "Tasks", 3, state.selectedIndex),
                      buildDrawerItem(context, Icons.request_page, "Leave Requests", 4, state.selectedIndex),
                      buildDrawerItem(context, Icons.announcement_outlined, "Announcements", 5, state.selectedIndex),
                      buildDrawerItem(context, Icons.inbox, "Requests", 6, state.selectedIndex),
                      buildDrawerItem(context, Icons.person_outline, "Profile", 7, state.selectedIndex),
                      const Spacer(),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.grey),
                        title: const Text("Logout", style: TextStyle(color: Colors.grey)),
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('token');
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const LoginPage()),
                            (route) => false,
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              body: _pages[state.selectedIndex],
            ),
          );
        },
      ),
    );
  }
}

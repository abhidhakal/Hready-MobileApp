import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/employee/presentation/view/employee_announcements.dart';
import 'package:hready/features/employee/presentation/view/employee_attendance.dart';
import 'package:hready/features/employee/presentation/view/employee_leave.dart';
import 'package:hready/features/employee/presentation/view/employee_profile.dart';
import 'package:hready/features/employee/presentation/view/employee_home.dart';
import 'package:hready/features/employee/presentation/view/employee_tasks.dart';
import 'package:hready/features/employee/presentation/viewmodel/employee_dashboard_event.dart';
import 'package:hready/features/employee/presentation/viewmodel/employee_dashboard_state.dart';
import 'package:hready/features/employee/presentation/viewmodel/employee_dashboard_view_model.dart';

class DashboardEmployee extends StatelessWidget {
  const DashboardEmployee({super.key});

  static final List<Widget> _pages = [
    const EmployeeHome(),
    const EmployeeLeave(),
    const EmployeeAttendance(),
    const EmployeeTasks(),
    const EmployeeAnnouncements(),
    const EmployeeProfile(),
  ];

  Widget buildNavItem(BuildContext context, IconData icon, String label, int index, int selectedIndex) {
    return GestureDetector(
      onTap: () => context.read<EmployeeDashboardViewModel>().add(EmployeeTabChanged(index)),
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EmployeeDashboardViewModel(),
      child: BlocBuilder<EmployeeDashboardViewModel, EmployeeDashboardState>(
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(child: _pages[state.selectedIndex]),
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
                      buildNavItem(context, Icons.home_outlined, "Home", 0, state.selectedIndex),
                      buildNavItem(context, Icons.beach_access, "Leave", 1, state.selectedIndex),
                      buildNavItem(context, Icons.fingerprint, "Attendance", 2, state.selectedIndex),
                      buildNavItem(context, Icons.assignment_outlined, "Tasks", 3, state.selectedIndex),
                      buildNavItem(context, Icons.announcement_outlined, "News", 4, state.selectedIndex),
                      buildNavItem(context, Icons.person_outline, "Profile", 5, state.selectedIndex),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

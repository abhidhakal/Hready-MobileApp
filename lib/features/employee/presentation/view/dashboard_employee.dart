import 'package:flutter/material.dart';
import 'package:hready/features/employee/presentation/view/employee_attendance.dart';
import 'package:hready/features/employee/presentation/view/employee_leave.dart';
import 'package:hready/features/employee/presentation/view/employee_home.dart';
import 'package:hready/features/employee/presentation/view/employee_tasks.dart';
import 'package:hready/features/employee/presentation/view/employee_requests.dart';
import 'package:hready/features/employee/presentation/view/employee_payroll.dart';
import 'package:shake/shake.dart';
import 'package:flutter/services.dart';
import 'package:hready/core/notifications/notification_manager.dart';
import 'package:hready/core/sensors/dashboard_proximity_service.dart';

class DashboardEmployee extends StatefulWidget {
  const DashboardEmployee({super.key});

  @override
  State<DashboardEmployee> createState() => _DashboardEmployeeState();
}

class _DashboardEmployeeState extends State<DashboardEmployee> {
  ShakeDetector? detector;
  final DashboardProximityService _proximityService = DashboardProximityService();

  static final List<Widget> _pages = [
    const EmployeeHome(),
    const EmployeeLeave(),
    const EmployeeAttendance(),
    const EmployeeTasks(),
    const EmployeePayroll(),
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
    
    // Initialize proximity sensor for screen control
    _proximityService.initialize(
      onProximityDetected: () {
        print('EmployeeDashboard: Proximity detected - screen should turn off');
        // You can add screen off logic here or use the service's built-in functionality
      },
      onProximityLost: () {
        print('EmployeeDashboard: Proximity lost - screen should turn on');
        // You can add screen on logic here or use the service's built-in functionality
      },
    );
  }

  @override
  void dispose() {
    detector?.stopListening();
    _proximityService.dispose();
    super.dispose();
  }

  Widget buildNavItem(BuildContext context, IconData icon, String label, int index, int selectedIndex) {
    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
        // Clear notification count when user taps home tab
        if (index == 0) {
          notificationManager.resetCount();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Icon(icon, color: selectedIndex == index ? const Color(0xFF042F46) : Colors.grey),
              if (index == 0) // Home tab - show notification badge
                StreamBuilder<int>(
                  stream: notificationManager.notificationCountStream,
                  builder: (context, snapshot) {
                    final count = snapshot.data ?? notificationManager.notificationCount;
                    if (count > 0) {
                      return Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            count > 99 ? '99+' : count.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
            ],
          ),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildNavItem(context, Icons.home_outlined, "Home", 0, _selectedIndex),
                  buildNavItem(context, Icons.beach_access, "Leave", 1, _selectedIndex),
                  buildNavItem(context, Icons.fingerprint, "Attendance", 2, _selectedIndex),
                  buildNavItem(context, Icons.assignment_outlined, "Tasks", 3, _selectedIndex),
                  buildNavItem(context, Icons.payment, "Payroll", 4, _selectedIndex),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
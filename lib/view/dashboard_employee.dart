import 'package:flutter/material.dart';

class DashboardEmployee extends StatefulWidget {
  const DashboardEmployee({super.key});

  @override
  State<DashboardEmployee> createState() => _DashboardEmployeeState();
}

class _DashboardEmployeeState extends State<DashboardEmployee> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text("Employee Home Page", style: TextStyle(fontSize: 18))),
    Center(child: Text("Employee Tasks", style: TextStyle(fontSize: 18))),
    Center(child: Text("Employee Profile", style: TextStyle(fontSize: 18))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f5f5),
      appBar: AppBar(
        title: const Text("Employee Dashboard"),
        backgroundColor: const Color(0xFF042F46),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Color(0xFF042F46),
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.task_alt_outlined),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

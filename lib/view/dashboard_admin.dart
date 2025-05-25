import 'package:flutter/material.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text("Admin Home Page", style: TextStyle(fontSize: 18))),
    Center(child: Text("Admin Tasks", style: TextStyle(fontSize: 18))),
    Center(child: Text("Admin Profile", style: TextStyle(fontSize: 18))),
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
        title: const Text("Admin Dashboard"),
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
              color: Colors.black,
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

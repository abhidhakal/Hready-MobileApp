import 'package:flutter/material.dart';
import 'package:hready/features/auth/presentation/view/login.dart';

class EmployeeProfile extends StatelessWidget {
  const EmployeeProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = {
      'Name': 'John Doe',
      'Email': 'john.doe@example.com',
      'Position': 'Software Engineer',
      'Phone': '+977 9865206747',
    };

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Profile'),
      //   backgroundColor: const Color(0xFF042F46),
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // align all left
            children: [
              // Profile picture stuck to left
              Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/profile.webp'),
                ),
              ),
              const SizedBox(height: 24),
              // User details listed below, aligned left
              ...userData.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${entry.key}: ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF042F46),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Clear user session/token if needed
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

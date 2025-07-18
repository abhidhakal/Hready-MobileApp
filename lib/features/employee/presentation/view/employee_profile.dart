import 'package:flutter/material.dart';
import 'package:hready/features/auth/presentation/view/login.dart';

class EmployeeProfile extends StatelessWidget {
  const EmployeeProfile({super.key});

  // Helper to resolve profile picture URL
  String _resolveProfilePicture(String? picture) {
    if (picture == null || picture.isEmpty) return '';
    if (picture.startsWith('/uploads/')) {
      return 'http://192.168.18.175:3000$picture'; // <-- Use your API base URL
    }
    if (picture.startsWith('http')) return picture;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual user data from state/provider
    final userData = {
      'Name': 'John Doe',
      'Email': 'john.doe@example.com',
      'Position': 'Software Engineer',
      'Phone': '+977 9865206747',
    };
    final profilePicture = null; // TODO: Replace with actual user profile picture

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
                  backgroundImage: (profilePicture != null && profilePicture.isNotEmpty && _resolveProfilePicture(profilePicture).isNotEmpty)
                      ? NetworkImage(_resolveProfilePicture(profilePicture)) as ImageProvider
                      : const AssetImage('assets/images/profile.webp'),
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

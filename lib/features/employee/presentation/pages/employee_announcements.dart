import 'package:flutter/material.dart';

class EmployeeAnnouncements extends StatelessWidget {
  const EmployeeAnnouncements({super.key});

  @override
  Widget build(BuildContext context) {
    final announcements = [
      'Company annual meeting on June 5th.',
      'New health insurance plans available.',
      'Office will be closed on May 29th for a holiday.',
      // Add announcements dynamically from API later
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
        backgroundColor: const Color(0xFF042F46),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: announcements.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.announcement_outlined),
            title: Text(announcements[index]),
          );
        },
      ),
    );
  }
}

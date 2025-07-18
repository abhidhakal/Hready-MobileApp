import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/employee/presentation/viewmodel/employee_dashboard_view_model.dart';
import 'package:hready/features/employee/presentation/viewmodel/employee_dashboard_state.dart';
import 'package:intl/intl.dart';
import 'package:hready/features/employee/presentation/view/employee_profile.dart';

class EmployeeHome extends StatelessWidget {
  const EmployeeHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeDashboardViewModel, EmployeeDashboardState>(
      builder: (context, state) {
        final employee = state.employee;
        final name = employee?.name ?? 'Employee';
        final position = employee?.position ?? 'Employee';
        final profilePicture = employee?.profilePicture;
        final attendanceStatus = state.attendanceStatus;
        final leaveDaysLeft = state.leaveDaysLeft > 0 ? state.leaveDaysLeft : 15; // Placeholder
        final tasks = state.tasks;
        final announcements = state.announcements;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 2,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: profilePicture != null && profilePicture.isNotEmpty
                            ? NetworkImage(profilePicture) as ImageProvider
                            : const AssetImage('assets/images/profile.webp'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hello, $name', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text('Today’s Attendance: '),
                                Text(
                                  attendanceStatus,
                                  style: TextStyle(
                                    color: attendanceStatus == 'Checked In' || attendanceStatus == 'Checked Out'
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFF042F46)),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const EmployeeProfile()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Info Cards Row (Role and Leave Days Left)
              SizedBox(
                height: 120,
                child: Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        title: 'Role',
                        content: Text(position, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        color: Colors.white,
                        height: 120,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InfoCard(
                        title: 'Leave Days Left',
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('$leaveDaysLeft', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward, color: Color(0xFF042F46)),
                              onPressed: () {
                                // Navigate to request leave
                              },
                            ),
                          ],
                        ),
                        color: Colors.white,
                        height: 120,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Recent Tasks
              const Text('Task List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 2,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Expanded(child: Text('Task Name', style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(child: Text('Details', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),
                      const Divider(height: 16),
                      if (tasks.isNotEmpty)
                        ...tasks.take(3).map((task) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Expanded(child: Text(task.title ?? '')),
                                  Expanded(
                                    child: Text(
                                      task.status ?? '',
                                      style: TextStyle(
                                        color: task.status == 'Pending'
                                            ? Colors.orange
                                            : task.status == 'In Progress'
                                                ? Colors.blue
                                                : Colors.green,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        // Navigate to task details
                                      },
                                      child: const Text('Details'),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      else
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: Text('No tasks assigned to you.')),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Recent Announcements
              const Text('Recent Announcements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.error != null
                      ? Center(child: Text('Error: [${state.error}'))
                      : announcements.isEmpty
                          ? const Center(child: Text('No announcements available.'))
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: announcements.take(5).length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final ann = announcements[index];
                                return Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: 2,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(ann.title ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 4),
                                        Text(
                                          ann.message != null && ann.message!.length > 100
                                              ? ann.message!.substring(0, 100) + '...'
                                              : ann.message ?? '',
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          ann.createdAt != null
                                              ? DateFormat('yyyy-MM-dd').format(ann.createdAt!)
                                              : '',
                                          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
            ],
          ),
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final Widget content;
  final Color? color;
  final double? height;
  const _InfoCard({required this.title, required this.content, this.color, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 120,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              content,
            ],
          ),
        ),
      ),
    );
  }
}

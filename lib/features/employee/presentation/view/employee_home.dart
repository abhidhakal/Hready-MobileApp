import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/employee/presentation/view/employee_attendance.dart';
import 'package:hready/features/employee/presentation/viewmodel/employee_dashboard_view_model.dart';
import 'package:hready/features/employee/presentation/viewmodel/employee_dashboard_state.dart';
import 'package:intl/intl.dart';
import 'package:hready/features/employee/presentation/view/employee_profile.dart';
import 'package:hready/features/employee/presentation/view/employee_leave.dart';
import 'package:hready/features/employee/presentation/view/employee_tasks.dart';
import 'package:hready/features/employee/presentation/view/employee_announcements.dart';
import 'package:hready/features/announcements/presentation/view_model/announcement_view_model.dart';
import 'package:provider/provider.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:hready/features/employee/presentation/viewmodel/employee_dashboard_event.dart';

class EmployeeHome extends StatelessWidget {
  const EmployeeHome({super.key});

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
    return BlocBuilder<EmployeeDashboardViewModel, EmployeeDashboardState>(
      builder: (context, state) {
        final user = state.user;
        final name = user?.name ?? 'Employee';
        final position = user?.position ?? 'Employee';
        final profilePicture = user?.profilePicture;
        final attendanceStatus = state.attendanceStatus;
        final leaveDaysLeft = state.leaveDaysLeft > 0 ? state.leaveDaysLeft : 15; // Placeholder
        final tasks = state.tasks;
        final announcements = state.announcements;
        final email = user?.email ?? '-';
        final contactNo = user?.contactNo ?? '-';
        final department = user?.department ?? '-';
        final role = user?.role ?? '-';

        return RefreshIndicator(
          onRefresh: () async {
            context.read<EmployeeDashboardViewModel>().add(LoadEmployeeDashboard());
            // Wait for loading to finish
            await Future.doWhile(() async {
              await Future.delayed(const Duration(milliseconds: 100));
              final loading = context.read<EmployeeDashboardViewModel>().state.isLoading;
              return loading;
            });
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const EmployeeProfile()),
                            );
                          },
                          child: CircleAvatar(
                            radius: 36,
                            backgroundImage: (profilePicture != null && profilePicture.isNotEmpty && _resolveProfilePicture(profilePicture).isNotEmpty)
                                ? NetworkImage(_resolveProfilePicture(profilePicture)) as ImageProvider
                                : const AssetImage('assets/images/profile.webp'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Hello, $name', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  InkWell(
                                    child: Chip(
                                      label: Text(
                                        attendanceStatus,
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                      backgroundColor: (attendanceStatus == 'Checked In' || attendanceStatus == 'Checked Out')
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              if (attendanceStatus != 'Checked In' && attendanceStatus != 'Checked Out')
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (_) => const EmployeeAttendance()),
                                      );
                                    },
                                    child: const Text('Complete attendance', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500)),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings, color: Color(0xFF042F46)),
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
                          content: Text(user?.position ?? '-', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const EmployeeLeave()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF042F46),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  minimumSize: const Size(40, 36),
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                ),
                                child: const Text('Request', style: TextStyle(fontSize: 14)),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Task List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const EmployeeTasks()),
                        );
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Builder(
                      builder: (context) {
                        final activeTasks = tasks.where((t) => (t.status ?? '').toLowerCase() != 'completed').toList();
                        if (activeTasks.isNotEmpty) {
                          return Column(
                            children: activeTasks.take(3).map((task) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(task.title ?? '', style: const TextStyle(fontWeight: FontWeight.w500)),
                                        if (task.dueDate != null)
                                          Text(
                                            'Due: ' + DateFormat('yyyy-MM-dd').format(task.dueDate!),
                                            style: const TextStyle(fontSize: 13, color: Colors.grey),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Chip(
                                    label: Text(task.status ?? '', style: const TextStyle(color: Colors.white)),
                                    backgroundColor: (task.status == 'Pending')
                                        ? Colors.orange
                                        : (task.status == 'In Progress')
                                            ? Colors.blue
                                            : Colors.green,
                                  ),
                                ],
                              ),
                            )).toList(),
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.assignment_turned_in, size: 40, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text('No tasks assigned to you.', style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Recent Announcements
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Recent Announcements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const EmployeeAnnouncements()),
                        );
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ChangeNotifierProvider<AnnouncementViewModel>(
                  create: (_) => getIt<AnnouncementViewModel>()..loadAnnouncements(),
                  child: Consumer<AnnouncementViewModel>(
                    builder: (context, vm, _) {
                      final state = vm.state;
                      if (state.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state.error != null) {
                        return Center(child: Text('Error: \\${state.error}'));
                      } else if (state.announcements.isEmpty) {
                        return const Center(
                          child: Column(
                            children: [
                              Icon(Icons.campaign, size: 40, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('No announcements available.', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        );
                      } else {
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.announcements.take(3).length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final ann = state.announcements[index];
                            return Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 2,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.orange[100],
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.all(6),
                                          child: const Icon(Icons.campaign, color: Colors.orange, size: 20),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(ann.title ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
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
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
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

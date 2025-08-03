import 'package:flutter/material.dart';
import 'package:hready/features/admin/presentation/view/admin_leave.dart';
import 'package:provider/provider.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:hready/features/announcements/presentation/view_model/announcement_view_model.dart';
import 'package:intl/intl.dart';
import 'package:hready/features/admin/presentation/view/admin_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/employee/presentation/view_model/employee_bloc.dart';
import 'package:hready/features/leaves/presentation/view_model/leave_bloc.dart';
import 'package:hready/features/tasks/presentation/view_model/task_bloc.dart';
import 'package:hready/features/tasks/presentation/view_model/task_state.dart';
import 'package:hready/features/tasks/presentation/view_model/task_event.dart';
import 'package:hready/features/admin/presentation/view_model/admin_profile_bloc.dart';
import 'package:hready/features/admin/presentation/view_model/admin_profile_event.dart';
import 'package:hready/features/admin/presentation/view_model/admin_profile_state.dart';
import 'package:hready/features/admin/presentation/view/admin_tasks.dart';
import 'package:hready/features/admin/presentation/view/admin_announcements.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_bloc.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_state.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_event.dart';
import 'package:hready/features/admin/presentation/view/admin_attendance.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hready/core/network/api_base.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  String _resolveProfilePicture(String? picture) {
    if (picture == null || picture.isEmpty) return 'assets/images/profile.webp';
    if (picture.startsWith('/uploads')) {
      return '$apiBaseUrl$picture';
    }
    if (picture.startsWith('http')) return picture;
    return 'assets/images/profile.webp';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiBlocProvider(
          providers: [
            BlocProvider<EmployeeBloc>(
              create: (context) => EmployeeBloc(
                getAllEmployeesUseCase: getIt(),
                addEmployeeUseCase: getIt(),
                updateEmployeeUseCase: getIt(),
                deleteEmployeeUseCase: getIt(),
              )..add(LoadEmployees()),
            ),
            BlocProvider<LeaveBloc>(
              create: (context) => LeaveBloc(getIt())..add(LoadLeaves()),
            ),
            BlocProvider<TaskBloc>(
              create: (context) => TaskBloc(
                getAllTasksUseCase: getIt(),
                getMyTasksUseCase: getIt(),
                createTaskUseCase: getIt(),
                updateTaskUseCase: getIt(),
                deleteTaskUseCase: getIt(),
                getAllUsersUseCase: getIt(),
                updateMyTaskStatusUseCase: getIt(),
              )..add(const LoadTasks()),
            ),
          ],
          child: RefreshIndicator(
            onRefresh: () async {
              // Dispatch load events to all BLoCs
              context.read<EmployeeBloc>().add(LoadEmployees());
              context.read<LeaveBloc>().add(LoadLeaves());
              context.read<TaskBloc>().add(const LoadTasks());
              // Refresh announcements
              final annProvider = context.read<AnnouncementViewModel>();
              await annProvider.loadAnnouncements();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Banner
                  BlocProvider(
                    create: (_) => AdminProfileBloc()..add(LoadAdminProfile()),
                    child: BlocBuilder<AdminProfileBloc, AdminProfileState>(
                      builder: (context, state) {
                        final name = (state.name.isNotEmpty) ? state.name : 'Admin';
                        final firstName = name.split(' ').first;
                        final profilePicture = state.profilePicture;
                        return BlocProvider(
                          create: (_) => getIt<AttendanceBloc>()..add(LoadTodayAttendance()),
                          child: BlocBuilder<AttendanceBloc, AttendanceState>(
                            builder: (context, attState) {
                              String attendance = '-';
                              Color attColor = Colors.red;
                              if (attState is AttendanceLoaded) {
                                attendance = attState.todayStatus;
                                if (attendance == 'Checked In' || attendance == 'Checked Out' || attendance == 'Present') {
                                  attColor = Colors.green;
                                } else if (attendance == 'Checked Out') {
                                  attColor = Colors.blue;
                                }
                              }
                              return Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                elevation: 4,
                                color: Colors.blueGrey[50],
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 38,
                                        backgroundColor: Colors.grey[200],
                                        child: ClipOval(
                                          child: (profilePicture.isNotEmpty && _resolveProfilePicture(profilePicture).isNotEmpty)
                                              ? Image.network(
                                                  _resolveProfilePicture(profilePicture),
                                                  width: 76,
                                                  height: 76,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/profile.webp', width: 76, height: 76, fit: BoxFit.cover),
                                                )
                                              : Image.asset('assets/images/profile.webp', width: 76, height: 76, fit: BoxFit.cover),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Hello, $firstName!', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 6),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(builder: (_) => const AdminAttendance()),
                                                    );
                                                  },
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: attColor.withOpacity(0.15),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Text(
                                                      attendance,
                                                      style: TextStyle(color: attColor, fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.settings, color: Color(0xFF042F46)),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (_) => const AdminProfilePage()),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Info Cards Row
                  SizedBox(
                    height: 160,
                    child: Row(
                      children: [
                        Expanded(
                          child: BlocBuilder<EmployeeBloc, EmployeeState>(
                            builder: (context, state) {
                              int active = 0, onLeave = 0, absent = 0;
                              if (state is EmployeeLoaded) {
                                for (final emp in state.employees) {
                                  if (emp.status.toLowerCase() == 'active') active++;
                                  else if (emp.status.toLowerCase() == 'on leave') onLeave++;
                                  else if (emp.status.toLowerCase() == 'absent') absent++;
                                }
                              }
                              return _InfoCard(
                                title: 'Today’s Overview',
                                content: Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Active: $active', overflow: TextOverflow.ellipsis),
                                      Text('On Leave: $onLeave', overflow: TextOverflow.ellipsis),
                                      Text('Absent: $absent', overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                                color: Colors.white,
                                height: 160,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: BlocBuilder<EmployeeBloc, EmployeeState>(
                            builder: (context, state) {
                              int total = 0;
                              if (state is EmployeeLoaded) {
                                total = state.employees.length;
                              }
                              return _InfoCard(
                                title: 'Total Employees',
                                content: Expanded(
                                  child: Text(
                                    '$total',
                                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                color: Colors.white,
                                height: 160,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Pending Leave Requests Card
                  BlocBuilder<LeaveBloc, LeaveState>(
                    builder: (context, state) {
                      int pending = 0;
                      if (state is LeaveLoaded) {
                        pending = state.leaves.where((l) => l.status?.toLowerCase() == 'pending').length;
                      }
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 2,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Pending Leave Requests', style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  Text('$pending', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const AdminLeave()),
                                  );
                                },
                                child: const Text('Review'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Recent Tasks Header with View All
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recent Tasks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => AdminTasks()),
                          );
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<TaskBloc, TaskState>(
                    builder: (context, state) {
                      if (state is TaskLoading) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 4,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                              child: Row(
                                children: [
                                  Container(
                                    width: 76,
                                    height: 76,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(38),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(height: 22, width: 120, color: Colors.white),
                                        const SizedBox(height: 10),
                                        Container(height: 16, width: 80, color: Colors.white),
                                        const SizedBox(height: 10),
                                        Container(height: 16, width: 60, color: Colors.white),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else if (state is TaskError) {
                        return Center(child: Text('Error: ${state.error}'));
                      } else if (state is TaskLoaded && state.tasks.isNotEmpty) {
                        final tasks = state.tasks.take(3).toList();
                        return Column(
                          children: [
                            for (final task in tasks)
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => AdminTasks()),
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: 2,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            task.title ?? '-',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            task.dueDate != null ? DateFormat('yyyy-MM-dd').format(task.dueDate!) : '-',
                                            style: const TextStyle(fontSize: 13, color: Colors.red),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: (task.status?.toLowerCase() == 'pending') ? Colors.orange[100] : Colors.green[100],
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            task.status ?? '-',
                                            style: TextStyle(
                                              color: (task.status?.toLowerCase() == 'pending') ? Colors.orange[800] : Colors.green[800],
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }
                      return const Center(child: Text('No recent tasks.'));
                    },
                  ),
                  const SizedBox(height: 24),
                  // Recent Announcements Header with View All
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recent Announcements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => AdminAnnouncements()),
                          );
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Recent Announcements Card List
                  ChangeNotifierProvider<AnnouncementViewModel>(
                    create: (_) => getIt<AnnouncementViewModel>()..loadAnnouncements(),
                    child: Consumer<AnnouncementViewModel>(
                      builder: (context, vm, _) {
                        final state = vm.state;
                        if (state.isLoading) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              elevation: 4,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 76,
                                      height: 76,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(38),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(height: 22, width: 120, color: Colors.white),
                                          const SizedBox(height: 10),
                                          Container(height: 16, width: 80, color: Colors.white),
                                          const SizedBox(height: 10),
                                          Container(height: 16, width: 60, color: Colors.white),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else if (state.error != null) {
                          return Center(child: Text('Error: ${state.error}'));
                        } else if (state.announcements.isEmpty) {
                          return const Center(child: Text('No announcements available.'));
                        }
                        final announcements = state.announcements.take(5).toList();
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: announcements.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final ann = announcements[index];
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => AdminAnnouncements()),
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 2,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.campaign, color: Colors.orange, size: 28),
                                      const SizedBox(width: 12),
                                      Expanded(
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
                                            if (ann.message != null && ann.message!.length > 100)
                                              TextButton(
                                                onPressed: () {
                                                  // Show full announcement (could use a dialog or new page)
                                                },
                                                child: const Text('Read More'),
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
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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

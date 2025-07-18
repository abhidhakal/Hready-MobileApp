import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/tasks/presentation/view_model/task_bloc.dart';
import 'package:hready/features/tasks/presentation/view_model/task_event.dart';
import 'package:hready/features/tasks/presentation/view_model/task_state.dart';
import 'package:hready/features/tasks/domain/entities/task_entity.dart';
import 'package:intl/intl.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:shimmer/shimmer.dart';

class EmployeeTasks extends StatelessWidget {
  const EmployeeTasks({super.key});

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'in progress':
        color = Colors.blue;
        break;
      case 'completed':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
    );
  }

  Widget _buildStatusMenu(BuildContext context, TaskEntity task) {
    if (task.id == null) {
      return _buildStatusChip(task.status ?? 'Pending');
    }
    final status = (task.status ?? 'Pending').toLowerCase();
    List<String> nextStatuses = [];
    if (status == 'pending') {
      nextStatuses = ['In Progress'];
    } else if (status == 'in progress') {
      nextStatuses = ['Completed'];
    }
    if (nextStatuses.isEmpty) {
      return _buildStatusChip(task.status ?? 'Pending');
    }
    return PopupMenuButton<String>(
      tooltip: 'Change status',
      onSelected: (selected) {
        context.read<TaskBloc>().add(UpdateMyTaskStatus(task.id!, selected));
      },
      itemBuilder: (context) => nextStatuses
          .map((s) => PopupMenuItem<String>(value: s, child: Text('Mark as $s')))
          .toList(),
      child: _buildStatusChip(task.status ?? 'Pending'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskBloc>(
      create: (_) => getIt<TaskBloc>()..add(const LoadTasks(onlyMyTasks: true)),
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Column(
              children: [
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(height: 20, width: 120, color: Colors.white, margin: const EdgeInsets.symmetric(vertical: 6)),
                                    Container(height: 16, width: 180, color: Colors.white, margin: const EdgeInsets.symmetric(vertical: 6)),
                                    Container(height: 14, width: 80, color: Colors.white, margin: const EdgeInsets.symmetric(vertical: 6)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is TaskError) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is TaskLoaded) {
            final myTasks = state.tasks;
            return Scaffold(
              appBar: AppBar(
                title: const Text('Tasks'),
                backgroundColor: const Color(0xFFF5F5F5),
                foregroundColor: Colors.black,
                centerTitle: false,
                elevation: 0,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Expanded(
                      child: myTasks.isNotEmpty
                          ? ListView.separated(
                        itemCount: myTasks.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final task = myTasks[index];
                          return Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 2,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(task.title ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 16, color: Colors.red),
                                      const SizedBox(width: 4),
                                      Text(
                                        task.dueDate != null ? DateFormat('yyyy-MM-dd').format(task.dueDate!) : '-',
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red),
                                      ),
                                    ],
                                  ),
                                  if (task.description != null && task.description!.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(task.description!, style: const TextStyle(fontSize: 15)),
                                  ],
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      _buildStatusMenu(context, task),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.assignment_turned_in, size: 80, color: Colors.grey),
                                  SizedBox(height: 16),
                                  Text('No tasks assigned to you.', style: TextStyle(color: Colors.grey, fontSize: 18)),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
} 
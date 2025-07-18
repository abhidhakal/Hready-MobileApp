import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/tasks/presentation/view_model/task_bloc.dart';
import 'package:hready/features/tasks/presentation/view_model/task_event.dart';
import 'package:hready/features/tasks/presentation/view_model/task_state.dart';
import 'package:hready/features/tasks/domain/entities/task_entity.dart';
import 'package:intl/intl.dart';
import 'package:hready/app/service_locator/service_locator.dart';

class EmployeeTasks extends StatelessWidget {
  const EmployeeTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskBloc>(
      create: (_) => getIt<TaskBloc>()..add(const LoadTasks(onlyMyTasks: true)),
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskError) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is TaskLoaded) {
            final myTasks = state.tasks;
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16),
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
                                  Text(task.description ?? '-', style: const TextStyle(fontSize: 16)),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        task.dueDate != null ? DateFormat('yyyy-MM-dd').format(task.dueDate!) : '-',
                                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Text('Status:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 8),
                                      DropdownButton<String>(
                                        value: task.status ?? 'Pending',
                                        items: const [
                                          DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                                          DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
                                          DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                                        ],
                                        onChanged: (newStatus) {
                                          if (newStatus != null && newStatus != task.status) {
                                            final updatedTask = TaskEntity(
                                              id: task.id,
                                              title: task.title,
                                              description: task.description,
                                              dueDate: task.dueDate,
                                              assignedTo: task.assignedTo,
                                              assignedDepartment: task.assignedDepartment,
                                              status: newStatus,
                                              createdBy: task.createdBy,
                                              createdAt: task.createdAt,
                                            );
                                            context.read<TaskBloc>().add(UpdateTask(task.id!, updatedTask));
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(child: Text('No tasks assigned to you.')),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
} 
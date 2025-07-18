import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:hready/features/tasks/presentation/view_model/task_bloc.dart';
import 'package:hready/features/tasks/presentation/view_model/task_event.dart';
import 'package:hready/features/tasks/presentation/view_model/task_state.dart';
import 'package:hready/features/tasks/domain/entities/task_entity.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class AdminTasks extends StatefulWidget {
  const AdminTasks({super.key});

  @override
  State<AdminTasks> createState() => _AdminTasksState();
}

class _AdminTasksState extends State<AdminTasks> {
  final _formKey = GlobalKey<FormState>();
  String? _editingTaskId;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _dueDate;
  String? _assignedTo;
  String? _assignedDepartment;
  String _status = 'Pending';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      _editingTaskId = null;
      _titleController.clear();
      _descriptionController.clear();
      _dueDate = null;
      _assignedTo = null;
      _assignedDepartment = null;
      _status = 'Pending';
    });
  }

  void _populateForm(TaskEntity task) {
    setState(() {
      _editingTaskId = task.id;
      _titleController.text = task.title ?? '';
      _descriptionController.text = task.description ?? '';
      _dueDate = task.dueDate;
      _assignedTo = task.assignedTo?.userId; // Use userId for the dropdown
      _assignedDepartment = task.assignedDepartment;
      _status = task.status ?? 'Pending';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskBloc>(
      create: (_) => getIt<TaskBloc>()..add(const LoadTasks()),
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskError) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is TaskLoaded) {
            final users = state.users;
            final tasks = state.tasks;
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 2,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Task List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns: const [
                                    DataColumn(label: Text('Title')),
                                    DataColumn(label: Text('Employee')),
                                    DataColumn(label: Text('Department')),
                                    DataColumn(label: Text('Due Date')),
                                    DataColumn(label: Text('Status')),
                                    DataColumn(label: Text('Actions')),
                                  ],
                                  rows: tasks.map((task) {
                                    return DataRow(cells: [
                                      DataCell(Text(task.title ?? '')),
                                      DataCell(Text(task.assignedTo != null ? '${task.assignedTo!.name} (${task.assignedTo!.email})' : '-')),
                                      DataCell(Text(task.assignedDepartment ?? '-')),
                                      DataCell(Text(task.dueDate != null ? DateFormat('yyyy-MM-dd').format(task.dueDate!) : '-')),
                                      DataCell(Text(task.status ?? '')),
                                      DataCell(Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit, color: Colors.blue),
                                            onPressed: () => _populateForm(task),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            onPressed: () => context.read<TaskBloc>().add(DeleteTask(task.id ?? '')),
                                          ),
                                        ],
                                      )),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _resetForm(); // Reset form for new task
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(_editingTaskId == null ? 'Add Task' : 'Edit Task'),
                        content: SizedBox(
                          width: 500,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: _titleController,
                                  decoration: const InputDecoration(labelText: 'Task Title'),
                                  validator: (v) => v == null || v.isEmpty ? 'Title required' : null,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _descriptionController,
                                  decoration: const InputDecoration(labelText: 'Description'),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InputDatePickerFormField(
                                        initialDate: _dueDate ?? DateTime.now(),
                                        firstDate: DateTime(2020),
                                        lastDate: DateTime(2100),
                                        fieldLabelText: 'Due Date',
                                        onDateSubmitted: (date) => setState(() => _dueDate = date),
                                        onDateSaved: (date) => setState(() => _dueDate = date),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    return DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      value: _assignedTo,
                                      items: [
                                        const DropdownMenuItem(value: null, child: Text('Assign to Employee')),
                                        ...users.map((u) => DropdownMenuItem(
                                              value: u.userId,
                                              child: Text('${u.name} (${u.department ?? 'N/A'})'),
                                            )),
                                      ],
                                      onChanged: (v) => setState(() => _assignedTo = v),
                                      decoration: const InputDecoration(labelText: 'Employee'),
                                    );
                                  },
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  decoration: const InputDecoration(labelText: 'Or Assign to Department'),
                                  initialValue: _assignedDepartment,
                                  onChanged: (v) => setState(() => _assignedDepartment = v),
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String>(
                                  value: _status,
                                  items: const [
                                    DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                                    DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
                                    DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                                  ],
                                  onChanged: (v) => setState(() => _status = v ?? 'Pending'),
                                  decoration: const InputDecoration(labelText: 'Status'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                final assignedUser = users.firstWhereOrNull((u) => u.userId == _assignedTo);
                                final entity = TaskEntity(
                                  id: _editingTaskId,
                                  title: _titleController.text.trim(),
                                  description: _descriptionController.text.trim(),
                                  dueDate: _dueDate,
                                  assignedTo: assignedUser,
                                  assignedDepartment: _assignedDepartment,
                                  status: _status,
                                );
                                if (_editingTaskId == null) {
                                  context.read<TaskBloc>().add(AddTask(entity));
                                } else {
                                  context.read<TaskBloc>().add(UpdateTask(_editingTaskId!, entity));
                                }
                                Navigator.of(context).pop(); // Close dialog
                              }
                            },
                            child: Text(_editingTaskId == null ? 'Add Task' : 'Update Task'),
                          ),
                          if (_editingTaskId != null)
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close dialog
                              },
                              child: const Text('Cancel'),
                            ),
                        ],
                      );
                    },
                  );
                },
                child: const Icon(Icons.add),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
} 
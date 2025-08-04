import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:hready/features/tasks/presentation/view_model/task_bloc.dart';
import 'package:hready/features/tasks/presentation/view_model/task_event.dart';
import 'package:hready/features/tasks/presentation/view_model/task_state.dart';
import 'package:hready/features/tasks/domain/entities/task_entity.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hready/core/utils/common_snackbar.dart';

class AdminTasks extends StatefulWidget {
  const AdminTasks({Key? key}) : super(key: key);

  @override
  State<AdminTasks> createState() => _AdminTasksState();
}

class _AdminTasksState extends State<AdminTasks> {
  final _formKey = GlobalKey<FormState>();
  String? _editingTaskId;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  DateTime? _dueDate;
  String? _assignedTo;
  String? _assignedDepartment;
  String _status = 'Pending';
  bool _showDialog = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      _editingTaskId = null;
      _titleController.clear();
      _descriptionController.clear();
      _departmentController.clear();
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
      _departmentController.text = task.assignedDepartment ?? '';
      _dueDate = task.dueDate;
      _assignedTo = task.assignedTo?.userId;
      _assignedDepartment = task.assignedDepartment;
      _status = task.status ?? 'Pending';
    });
  }

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

  Widget _buildAvatar(String? name) {
    return CircleAvatar(
      backgroundColor: Colors.blue[100],
      child: Text(
        (name != null && name.isNotEmpty) ? name[0].toUpperCase() : '?',
        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showTaskDialog(BuildContext context, List users, TaskBloc taskBloc) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(_editingTaskId == null ? 'Add Task' : 'Edit Task'),
              content: SizedBox(
                width: 400,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(labelText: 'Task Title', border: OutlineInputBorder()),
                          validator: (v) => v == null || v.isEmpty ? 'Title required' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: _dueDate ?? DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null) {
                                    setState(() => _dueDate = picked);
                                    setDialogState(() {}); // Rebuild the dialog
                                  }
                                },
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: 'Due Date',
                                    border: OutlineInputBorder(),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 18),
                                      const SizedBox(width: 8),
                                      Text(_dueDate != null ? DateFormat('yyyy-MM-dd').format(_dueDate!) : 'Select date'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: _assignedTo,
                          items: [
                            const DropdownMenuItem(value: null, child: Text('Assign to Employee')),
                            ...users.map((u) => DropdownMenuItem(
                                  value: u.userId,
                                  child: Text('${u.name} (${u.department ?? 'N/A'})'),
                                )),
                          ],
                          onChanged: (v) {
                            setState(() => _assignedTo = v);
                            setDialogState(() {}); // Rebuild the dialog
                          },
                          decoration: const InputDecoration(labelText: 'Employee', border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _departmentController,
                          decoration: const InputDecoration(labelText: 'Or Assign to Department', border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _status,
                          items: const [
                            DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                            DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
                            DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                          ],
                          onChanged: (v) {
                            setState(() => _status = v ?? 'Pending');
                            setDialogState(() {}); // Rebuild the dialog
                          },
                          decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final assignedUser = _assignedTo != null ? users.firstWhereOrNull((u) => u.userId == _assignedTo) : null;
                      final entity = TaskEntity(
                        id: _editingTaskId,
                        title: _titleController.text.trim(),
                        description: _descriptionController.text.trim(),
                        dueDate: _dueDate,
                        assignedTo: assignedUser,
                        assignedDepartment: _departmentController.text.trim().isNotEmpty ? _departmentController.text.trim() : null,
                        status: _status,
                      );
                      if (_editingTaskId == null) {
                        taskBloc.add(AddTask(entity));
                      } else {
                        taskBloc.add(UpdateTask(_editingTaskId!, entity));
                      }
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(_editingTaskId == null ? 'Add Task' : 'Update Task'),
                ),
                if (_editingTaskId != null)
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskBloc>(
      create: (_) => getIt<TaskBloc>()..add(const LoadTasks()),
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Tasks'),
                backgroundColor: const Color(0xFFF5F5F5),
                foregroundColor: Colors.black,
                centerTitle: false,
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          title: Container(height: 16, width: 120, color: Colors.white, margin: const EdgeInsets.symmetric(vertical: 4)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(height: 12, width: 180, color: Colors.white, margin: const EdgeInsets.symmetric(vertical: 4)),
                              Container(height: 12, width: 80, color: Colors.white, margin: const EdgeInsets.symmetric(vertical: 4)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else if (state is TaskError) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is TaskLoaded) {
            final users = state.users;
            final tasks = state.tasks;
            return Scaffold(
              appBar: AppBar(
                title: const Text('Tasks'),
                backgroundColor: const Color(0xFFF5F5F5),
                foregroundColor: Colors.black,
                centerTitle: false,
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        tasks.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.assignment_turned_in, size: 80, color: Colors.grey),
                                    SizedBox(height: 16),
                                    Text('No tasks found.', style: TextStyle(color: Colors.grey, fontSize: 18)),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: tasks.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 16),
                                itemBuilder: (context, index) {
                              final task = tasks[index];
                              return Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 2,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                  leading: _buildAvatar(task.assignedTo?.name),
                                  title: Text(task.title ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (task.description != null && task.description!.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                                          child: Text(task.description!, style: const TextStyle(fontSize: 14)),
                                        ),
                                      Row(
                                        children: [
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(task.assignedTo != null ? '${task.assignedTo!.name} (${task.assignedTo!.department ?? '-'})' : '-', style: const TextStyle(fontSize: 13)),
                                                const SizedBox(height: 4),
                                                Text(task.dueDate != null ? DateFormat('yyyy-MM-dd').format(task.dueDate!) : '-', style: const TextStyle(fontSize: 13)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          _buildStatusChip(task.status ?? ''),
                                          const SizedBox(width: 12),
                                          if (task.assignedDepartment != null && task.assignedDepartment!.isNotEmpty)
                                            Row(
                                              children: [
                                                const Icon(Icons.apartment, size: 16, color: Colors.teal),
                                                const SizedBox(width: 4),
                                                Text(task.assignedDepartment!, style: const TextStyle(fontSize: 13)),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        _populateForm(task);
                                        _showTaskDialog(context, users, context.read<TaskBloc>());
                                      } else if (value == 'delete') {
                                        context.read<TaskBloc>().add(DeleteTask(task.id ?? ''));
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(value: 'edit', child: ListTile(leading: Icon(Icons.edit), title: Text('Edit'))),
                                      const PopupMenuItem(value: 'delete', child: ListTile(leading: Icon(Icons.delete), title: Text('Delete'))),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _resetForm();
                  _showTaskDialog(context, users, context.read<TaskBloc>());
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
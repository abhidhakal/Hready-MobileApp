import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:hready/features/employee/presentation/view_model/employee_bloc.dart';
import 'package:hready/features/employee/domain/entities/employee_entity.dart';

class AdminEmployees extends StatefulWidget {
  const AdminEmployees({super.key});

  @override
  State<AdminEmployees> createState() => _AdminEmployeesState();
}

class _AdminEmployeesState extends State<AdminEmployees> {
  EmployeeEntity? _editingEmployee;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  String _status = 'active';
  bool _showPassword = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _contactNoController.dispose();
    _departmentController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _editingEmployee = null;
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _contactNoController.clear();
    _departmentController.clear();
    _positionController.clear();
    _status = 'active';
    _showPassword = false;
  }

  void _populateForm(EmployeeEntity emp) {
    _editingEmployee = emp;
    _nameController.text = emp.name;
    _emailController.text = emp.email;
    _passwordController.clear();
    _contactNoController.text = emp.contactNo;
    _departmentController.text = emp.department;
    _positionController.text = emp.position;
    _status = emp.status;
    _showPassword = false;
  }

  void _showEmployeeDialog(BuildContext context, {EmployeeEntity? employee}) {
    if (employee != null) {
      _populateForm(employee);
    } else {
      _resetForm();
    }
    showDialog(
      context: context,
      builder: (context) {
        final _formKey = GlobalKey<FormState>();
        return AlertDialog(
          title: Text(employee == null ? 'Add Employee' : 'Edit Employee'),
          content: SizedBox(
            width: 400,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                      validator: (v) => v == null || v.isEmpty ? 'Name required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                      validator: (v) => v == null || v.isEmpty ? 'Email required' : null,
                    ),
                    const SizedBox(height: 16),
                    if (employee == null)
                      StatefulBuilder(
                        builder: (context, setState) => TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                              onPressed: () => setState(() => _showPassword = !_showPassword),
                            ),
                          ),
                          obscureText: !_showPassword,
                          validator: (v) => v == null || v.isEmpty ? 'Password required' : null,
                        ),
                      ),
                    if (employee == null) const SizedBox(height: 16),
                    TextFormField(
                      controller: _contactNoController,
                      decoration: const InputDecoration(labelText: 'Contact No', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _departmentController,
                      decoration: const InputDecoration(labelText: 'Department', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _positionController,
                      decoration: const InputDecoration(labelText: 'Position', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _status,
                      items: const [
                        DropdownMenuItem(value: 'active', child: Text('Active')),
                        DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                      ],
                      onChanged: (v) => setState(() => _status = v ?? 'active'),
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
                Navigator.of(context).pop();
                _resetForm();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final emp = EmployeeEntity(
                    employeeId: _editingEmployee?.employeeId,
                    name: _nameController.text.trim(),
                    email: _emailController.text.trim(),
                    password: employee == null ? _passwordController.text : '',
                    profilePicture: '',
                    contactNo: _contactNoController.text.trim(),
                    role: 'employee',
                    department: _departmentController.text.trim(),
                    position: _positionController.text.trim(),
                    status: _status,
                  );
                  if (employee == null) {
                    context.read<EmployeeBloc>().add(AddEmployee(emp));
                  } else {
                    context.read<EmployeeBloc>().add(UpdateEmployee(_editingEmployee!.employeeId!, emp));
                  }
                  Navigator.of(context).pop();
                  _resetForm();
                }
              },
              child: Text(employee == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmployeeList(List<EmployeeEntity> employees) {
    if (employees.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.group_off, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text('No employees found.', style: TextStyle(color: Colors.grey[700], fontSize: 18)),
          ],
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: employees.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final emp = employees[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text(
                emp.name.isNotEmpty ? emp.name[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(emp.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(emp.email, style: const TextStyle(fontSize: 13)),
                Text('${emp.department} • ${emp.position}', style: const TextStyle(fontSize: 13, color: Colors.black54)),
                Text('Status: ${emp.status}', style: TextStyle(fontSize: 12, color: emp.status == 'active' ? Colors.green : Colors.red)),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _showEmployeeDialog(context, employee: emp);
                } else if (value == 'delete') {
                  context.read<EmployeeBloc>().add(DeleteEmployee(emp.employeeId!));
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: ListTile(leading: Icon(Icons.edit), title: Text('Edit'))),
                const PopupMenuItem(value: 'delete', child: ListTile(leading: Icon(Icons.delete), title: Text('Delete'))),
              ],
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmployeeBloc>(
      create: (_) => getIt<EmployeeBloc>()..add(LoadEmployees()),
      child: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeeError) {
            return Center(child: Text('Error: ${state.error}'));
          }
          final employees = state is EmployeeLoaded ? state.employees : <EmployeeEntity>[];
          return Scaffold(
            appBar: AppBar(
              title: const Text('Manage Employees'),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildEmployeeList(employees),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showEmployeeDialog(context),
              tooltip: 'Add Employee',
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}

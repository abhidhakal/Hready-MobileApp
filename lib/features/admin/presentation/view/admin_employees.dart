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
            width: 500,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (v) => v == null || v.isEmpty ? 'Name required' : null,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (v) => v == null || v.isEmpty ? 'Email required' : null,
                    ),
                    const SizedBox(height: 8),
                    if (employee == null)
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (v) => v == null || v.isEmpty ? 'Password required' : null,
                      ),
                    if (employee == null) const SizedBox(height: 8),
                    TextFormField(
                      controller: _contactNoController,
                      decoration: const InputDecoration(labelText: 'Contact No'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _departmentController,
                      decoration: const InputDecoration(labelText: 'Department'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _positionController,
                      decoration: const InputDecoration(labelText: 'Position'),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _status,
                      items: const [
                        DropdownMenuItem(value: 'active', child: Text('Active')),
                        DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                      ],
                      onChanged: (v) => setState(() => _status = v ?? 'active'),
                      decoration: const InputDecoration(labelText: 'Status'),
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
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Department')),
                        DataColumn(label: Text('Position')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: employees.isNotEmpty
                          ? employees.map((emp) {
                              return DataRow(cells: [
                                DataCell(Text(emp.name)),
                                DataCell(Text(emp.email)),
                                DataCell(Text(emp.department)),
                                DataCell(Text(emp.position)),
                                DataCell(Text(emp.status)),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => _showEmployeeDialog(context, employee: emp),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => context.read<EmployeeBloc>().add(DeleteEmployee(emp.employeeId!)),
                                    ),
                                  ],
                                )),
                              ]);
                            }).toList()
                          : [
                              const DataRow(cells: [
                                DataCell(Text('-')),
                                DataCell(Text('-')),
                                DataCell(Text('-')),
                                DataCell(Text('-')),
                                DataCell(Text('-')),
                                DataCell(Text('-')),
                                DataCell(Text('-')),
                              ]),
                            ],
                    ),
                  ),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showEmployeeDialog(context),
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}

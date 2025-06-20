import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/auth/presentation/viewmodel/auth_event.dart';
import 'package:hready/features/auth/presentation/viewmodel/auth_state.dart';
import 'package:hready/features/auth/presentation/viewmodel/auth_view_model.dart';
import 'package:hready/features/admin/data/models/admin_hive_model.dart';
import 'package:hready/features/employee/data/models/employee_hive_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final nameController = TextEditingController();
  final myKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  String selectedRole = 'admin'; // default

  final List<String> roles = ['admin', 'employee'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: BlocListener<AuthViewModel, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Registered successfully")),
              );
              Navigator.pop(context);
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: myKey,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Image.asset('assets/images/light.webp', height: 100),
                    const SizedBox(height: 24),
                    const Text("Register", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
                    const SizedBox(height: 24),

                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      items: roles
                          .map((role) => DropdownMenuItem(
                                value: role,
                                child: Text(role[0].toUpperCase() + role.substring(1)),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => selectedRole = value!),
                      decoration: const InputDecoration(labelText: 'Select Role'),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) => value!.isEmpty ? 'Enter your name' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) => value!.isEmpty ? 'Enter your email' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: pwController,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (myKey.currentState!.validate()) {
                            final email = emailController.text.trim();
                            final password = pwController.text.trim();
                            final name = nameController.text.trim();

                            if (selectedRole == 'admin') {
                              final admin = AdminHiveModel(
                                adminId: DateTime.now().millisecondsSinceEpoch.toString(),
                                name: name,
                                email: email,
                                password: password,
                                profilePicture: '',
                                contactNo: '',
                                role: 'admin',
                              );
                              context.read<AuthViewModel>().add(RegisterAdmin(admin));
                            } else {
                              final employee = EmployeeHiveModel(
                                employeeId: DateTime.now().millisecondsSinceEpoch.toString(),
                                name: name,
                                email: email,
                                password: password,
                                profilePicture: '',
                                contactNo: '',
                                role: 'employee',
                                department: '',
                                position: '',
                              );
                              context.read<AuthViewModel>().add(RegisterEmployee(employee));
                            }
                          }
                        },
                        child: const Text('REGISTER', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

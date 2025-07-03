import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/auth/presentation/view/register.dart';
import 'package:hready/features/auth/presentation/viewmodel/auth_event.dart';
import 'package:hready/features/auth/presentation/viewmodel/auth_state.dart';
import 'package:hready/features/auth/presentation/viewmodel/auth_view_model.dart';
import 'package:hready/features/admin/presentation/view/dashboard_admin.dart';
import 'package:hready/features/employee/presentation/view/dashboard_employee.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final myKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthViewModel, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              final role = state.user.role;
              if (role == 'admin') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const DashboardAdmin()),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const DashboardEmployee()),
                );
              }
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: myKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/light.webp', height: 100),
                  const SizedBox(height: 24),
                  const Text(
                    "Welcome to HReady!",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                  ),
                  const SizedBox(height: 42),

                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Enter your email'),
                    validator: (value) => value == null || value.isEmpty
                        ? "Please enter your email"
                        : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: pwController,
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Enter your password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
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
                          context.read<AuthViewModel>().add(
                                LoginRequested(email, password),
                              );
                        }
                      },
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      ),
                      child: const Text("Don't have an account? Register here"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

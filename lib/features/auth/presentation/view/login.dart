import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/auth/presentation/view/register.dart';
import 'package:hready/features/auth/presentation/view_model/auth_event.dart';
import 'package:hready/features/auth/presentation/view_model/auth_state.dart';
import 'package:hready/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:hready/features/admin/presentation/view/dashboard_admin.dart';
import 'package:hready/features/employee/presentation/view/dashboard_employee.dart';
import 'package:hready/core/widgets/app_snackbar.dart';
import 'package:hready/core/utils/validators.dart';
import 'package:hready/core/constants/app_constants.dart';
import 'package:hready/core/enums/app_enums.dart';
import 'package:hready/core/extensions/app_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);
    if (token != null && token.isNotEmpty) {
      try {
        final decoded = JwtDecoder.decode(token);
        final isExpired = JwtDecoder.isExpired(token);
        if (!isExpired) {
          final role = prefs.getString(AppConstants.userRoleKey);
          final userId = prefs.getString(AppConstants.userIdKey);
          if (role == UserRole.admin.name) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardAdmin()));
          } else if (role == UserRole.employee.name) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardEmployee()));
          }
        } else {
          await prefs.clear();
        }
      } catch (e) {
        await prefs.clear();
      }
    }
  }

  void _handleLogin(String token, String userId, String role, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, token);
    await prefs.setString(AppConstants.userIdKey, userId);
    await prefs.setString(AppConstants.userRoleKey, role);
    await prefs.setString('userName', name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthViewModel, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              final role = state.user.role;
              if (role == UserRole.admin.name) {
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
              context.showErrorSnackBar(state.message);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: myKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/primary_transparent.webp', height: 100),
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
                    validator: FormValidators.email,
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
                    validator: FormValidators.password,
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
                  // SafeArea(
                  //   child: TextButton(
                  //     onPressed: () => Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (_) => const RegisterPage()),
                  //     ),
                  //     child: const Text("Don't have an account? Register here"),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

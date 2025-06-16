import 'package:flutter/material.dart';
import 'package:hready/features/admin/presentation/pages/dashboard_admin.dart';
import 'package:hready/features/employee/presentation/pages/dashboard_employee.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final myKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool stayLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ), 
                ),
                const SizedBox(height: 42),
        
                // Email Field
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Enter your email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
        
                // Password Field
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
        
                // Stay Logged In Checkbox
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: stayLoggedIn,
                        activeColor: const Color(0xFF042F46),
                        onChanged: (value) {
                          setState(() {
                            stayLoggedIn = value!;
                          });
                        },
                      ),
                      const Text(
                        "Stay logged in",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
        
                // Login Button
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      if (myKey.currentState!.validate()) {
                        final email = emailController.text.trim();
                        final password = pwController.text.trim();
        
                        if (email == "admin" && password == "admin123") {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const DashboardAdmin()),
                          );
                        } else if (email == "abhi" &&
                            password == "abhi123") {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const DashboardEmployee()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Invalid credentials")),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}

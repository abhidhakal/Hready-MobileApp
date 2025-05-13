import 'package:flutter/material.dart';
import 'package:hready/view/dashboard_admin.dart';
import 'package:hready/view/dashboard_employee.dart';

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
      backgroundColor: const Color(0xFFf5f5f5),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: myKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/light.png', height: 100),
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(
                      color: Color(0xFF042F46),
                      width: 2,
                    ),
                  ),
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(
                      color: Color(0xFF042F46),
                      width: 2,
                    ),
                  ),
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
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF042F46),
                    foregroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () {
                    if (myKey.currentState!.validate()) {
                      final email = emailController.text.trim();
                      final password = pwController.text.trim();

                      if (email == "admin@hready.com" && password == "admin123") {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DashboardAdmin()),
                        );
                      } else if (email == "abhinav@gmail.com" &&
                          password == "hello123") {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DashboardEmployee()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Invalid credentials")),
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
    );
  }
}

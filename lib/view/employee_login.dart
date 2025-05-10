import 'package:flutter/material.dart';

class EmployeeLogin extends StatefulWidget {
  const EmployeeLogin({super.key});

  @override
  State<EmployeeLogin> createState() => _EmployeeLoginState();
}

class _EmployeeLoginState extends State<EmployeeLogin> {
  final emailController = TextEditingController(text: "johndoe@gmail.com");
  final pwController = TextEditingController();
  final myKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: myKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/light.png', height: 100),

                // Email Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter your email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: Color(0xFF4b5fff), width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Password Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: Color(0xFF4b5fff), width: 2),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !isPasswordVisible,
                  controller: pwController,
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
                SizedBox(width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4b5fff),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                      )
                    ),
                    onPressed: (){},
                    child: Text('Login'),
                  ),
                ),
                SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    text: 'Login as',
                    style: TextStyle(
                      color: Colors.black12,
                      fontSize: 18,
                    ),
                    children: <TextSpan> [
                      TextSpan(
                        text: 'Admin',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )
                      )
                    ]
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
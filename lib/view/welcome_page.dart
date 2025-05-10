import 'package:flutter/material.dart';
import 'package:hready/view/admin_login.dart';
import 'package:hready/view/employee_login.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f5f5),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/light.png', height: 200),
              SizedBox(height: 24),
              RichText(text: TextSpan(
                text: "Welcome to HReady!",
                style: TextStyle(
                  color: Color(0xFF191919),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 48),
              RichText(text: TextSpan(
                        text: "Login as",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(height: 50, width: 300,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4b5fff),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        )
                      ),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AdminLogin()),
                          );
                      },
                      child: RichText(text: TextSpan(
                        text: "Login as Admin",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
              ),
              SizedBox(height: 8),
              RichText(text: TextSpan(
                        text: "or",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(height: 50, width: 300,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF04b386),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        )
                      ),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EmployeeLogin()),
                          );
                      },
                      child: RichText(text: TextSpan(
                        text: "Login as Employee",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
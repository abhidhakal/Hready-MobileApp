import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:hready/features/admin/presentation/view/dashboard_admin.dart';
import 'package:hready/features/auth/presentation/view/login.dart';
import 'package:hready/features/employee/presentation/view/dashboard_employee.dart';
import 'package:hready/features/splash/viewmodel/splash_event.dart';
import 'package:hready/features/splash/viewmodel/splash_state.dart';
import 'package:hready/features/splash/viewmodel/splash_view_model.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SplashViewModel>()..add(StartSplash()),
      child: BlocListener<SplashViewModel, SplashState>(
        listener: (context, state) {
          if (state is SplashLoggedIn) {
            if (state.user.role == "admin") {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const DashboardAdmin()),
              );
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const DashboardEmployee()),
              );
            }
          } else if (state is SplashNotLoggedIn) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/light.webp', height: 250),
                  const SizedBox(height: 16),
                  Lottie.asset(
                    'assets/animations/loading.json',
                    width: 400,
                    height: 100,
                    repeat: true,
                    animate: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

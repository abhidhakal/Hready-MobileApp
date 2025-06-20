import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/auth/presentation/view/login.dart';
import 'package:hready/features/splash/viewmodel/splash_event.dart';
import 'package:hready/features/splash/viewmodel/splash_state.dart';
import 'package:hready/features/splash/viewmodel/splash_view_model.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashViewModel()..add(StartSplash()),
      child: BlocListener<SplashViewModel, SplashState>(
        listener: (context, state) {
          if (state is SplashCompleted) {
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

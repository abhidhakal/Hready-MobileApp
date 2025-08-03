import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/app/theme/hready_theme.dart';
import 'package:hready/features/splash/view/splash_screen.dart';

// GetIt
import 'package:hready/app/service_locator/service_locator.dart';

// ViewModels
import 'package:hready/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:hready/features/admin/presentation/view_model/admin_dashboard_view_model.dart';
import 'package:hready/features/employee/presentation/view_model/employee_dashboard_view_model.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthViewModel>()),
        BlocProvider(create: (_) => getIt<AdminDashboardViewModel>()),
        BlocProvider(create: (_) => getIt<EmployeeDashboardViewModel>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HReady',
        theme: getApplicationTheme(),
        home: const SplashScreen(),
      ),
    );
  }
}


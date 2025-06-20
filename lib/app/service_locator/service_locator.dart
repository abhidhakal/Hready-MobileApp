import 'package:get_it/get_it.dart';
import 'package:hready/core/network/hive_service.dart';
import 'package:hready/features/admin/presentation/viewmodel/admin_dashboard_view_model.dart';

// Auth
import 'package:hready/features/auth/domain/repositories/auth_repository.dart';
import 'package:hready/features/auth/domain/use_cases/login_use_case.dart';
import 'package:hready/features/auth/domain/use_cases/register_admin_use_case.dart';
import 'package:hready/features/auth/domain/use_cases/register_employee_use_case.dart';
import 'package:hready/features/auth/presentation/viewmodel/auth_view_model.dart';

// Admin Dashboard

// Employee Dashboard
import 'package:hready/features/employee/presentation/viewmodel/employee_dashboard_view_model.dart';

// Splash
import 'package:hready/features/splash/viewmodel/splash_view_model.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Core
  getIt.registerLazySingleton(() => HiveService());

  // Auth
  getIt.registerLazySingleton(() => AuthRepository(getIt()));
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterAdminUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterEmployeeUseCase(getIt()));
  getIt.registerFactory(() => AuthViewModel(
        loginUseCase: getIt(),
        registerAdminUseCase: getIt(),
        registerEmployeeUseCase: getIt(),
      ));

  // Dashboards
  getIt.registerFactory(() => AdminDashboardViewModel());
  getIt.registerFactory(() => EmployeeDashboardViewModel());

  // Splash
  getIt.registerFactory(() => SplashViewModel());
}

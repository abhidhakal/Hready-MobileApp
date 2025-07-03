import 'package:get_it/get_it.dart';

// Core
import 'package:hready/core/network/api_service.dart';
import 'package:hive/hive.dart';
import 'package:hready/features/auth/data/datasources/remote_datasource/user_remote_data_source.dart';
import 'package:hready/features/auth/data/datasources/user_remote_data_source.dart';
import 'package:hready/features/auth/data/repositories/auth_remote_repository.dart';

// Auth
import 'package:hready/features/auth/domain/repositories/auth_repository.dart';
import 'package:hready/features/auth/domain/use_cases/login_use_case.dart';
import 'package:hready/features/auth/domain/use_cases/register_use_case.dart';
import 'package:hready/features/auth/domain/use_cases/get_cached_user_use_case.dart';
import 'package:hready/features/auth/presentation/viewmodel/auth_view_model.dart';
import 'package:hready/features/auth/data/models/user_hive_model.dart';

// Admin Dashboard
import 'package:hready/features/admin/presentation/viewmodel/admin_dashboard_view_model.dart';

// Employee Dashboard
import 'package:hready/features/employee/presentation/viewmodel/employee_dashboard_view_model.dart';

// Splash
import 'package:hready/features/splash/viewmodel/splash_view_model.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Core
  getIt.registerLazySingleton(() => ApiService('http://192.168.18.177:3000'));

  // Auth - Remote Datasource
  getIt.registerLazySingleton<IUserRemoteDatasource>(
  () => UserRemoteDatasource(getIt()),
);


  // Hive box for caching UserEntity
  final userBox = await Hive.openBox<UserHiveModel>('userBox');

  // Auth Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRemoteRepository(
      remoteDatasource: getIt<IUserRemoteDatasource>(),
      hiveBox: userBox,
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCachedUserUseCase(getIt()));

  // Auth ViewModel
  getIt.registerFactory(() => AuthViewModel(
        loginUseCase: getIt(),
        registerUseCase: getIt(),
        getCachedUserUseCase: getIt(),
      ));

  // Dashboards
  getIt.registerFactory(() => AdminDashboardViewModel());
  getIt.registerFactory(() => EmployeeDashboardViewModel());

  // Splash
  getIt.registerFactory(() => SplashViewModel());
}

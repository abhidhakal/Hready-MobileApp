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
import 'package:hready/features/auth/data/models/user_model.dart';

// Admin Dashboard
import 'package:hready/features/admin/presentation/viewmodel/admin_dashboard_view_model.dart';

// Employee Dashboard
import 'package:hready/features/employee/presentation/viewmodel/employee_dashboard_view_model.dart';

// Splash
import 'package:hready/features/splash/viewmodel/splash_view_model.dart';

// Announcements
import 'package:hready/features/announcements/data/datasources/remote_datasource/announcement_remote_data_source.dart';
import 'package:hready/features/announcements/data/repositories/announcement_remote_repository.dart';
import 'package:hready/features/announcements/domain/use_cases/get_announcements_use_case.dart';
import 'package:hready/features/announcements/domain/use_cases/create_announcement_use_case.dart';
import 'package:hready/features/announcements/domain/use_cases/update_announcement_use_case.dart';
import 'package:hready/features/announcements/domain/use_cases/delete_announcement_use_case.dart';
import 'package:hready/features/announcements/presentation/view_model/announcement_view_model.dart';
import 'package:hready/features/announcements/domain/repositories/announcement_repository.dart';
import 'package:dio/dio.dart';

// Tasks
import 'package:hready/features/tasks/data/datasources/remote_datasource/task_remote_data_source.dart';
import 'package:hready/features/tasks/data/repositories/task_remote_repository.dart';
import 'package:hready/features/tasks/domain/repositories/task_repository.dart';
import 'package:hready/features/tasks/domain/use_cases/get_my_tasks_use_case.dart';

// Attendance
import 'package:hready/features/attendance/data/datasources/remote_datasource/attendance_remote_data_source.dart';
import 'package:hready/features/attendance/data/repositories/attendance_remote_repository.dart';
import 'package:hready/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:hready/features/attendance/domain/use_cases/get_my_attendance_use_case.dart';

// Leaves
import 'package:hready/features/leaves/data/datasources/remote_datasource/leave_remote_data_source.dart';
import 'package:hready/features/leaves/data/repositories/leave_remote_repository.dart';
import 'package:hready/features/leaves/domain/repositories/leave_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Hive box for caching UserEntity
  final userBox = await Hive.openBox<UserHiveModel>('userBox');

  // Core - ApiService with getToken from Hive
  getIt.registerLazySingleton(() => ApiService(
        'http://192.168.18.174:3000',
        getToken: () async {
          final model = userBox.get('current_user');
          return model?.token;
        },
      ));

  // Auth - Remote Datasource
  getIt.registerLazySingleton<IUserRemoteDatasource>(
    () => UserRemoteDatasource(getIt()),
  );

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
  getIt.registerFactory(() => SplashViewModel(
        getCachedUserUseCase: getIt(),
      ));

  // Register Dio for API calls
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(baseUrl: 'http://192.168.18.174:3000/api'));
    // Optionally add an interceptor to always add the token
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
    return dio;
  });

  // Announcements - Remote Data Source
  getIt.registerLazySingleton(() => AnnouncementRemoteDataSource(getIt<Dio>()));

  // Announcements - Repository
  getIt.registerLazySingleton(() => AnnouncementRemoteRepository(getIt()));
  getIt.registerLazySingleton<AnnouncementRepository>(
    () => getIt<AnnouncementRemoteRepository>(),
  );

  // Announcements - Use Cases
  getIt.registerLazySingleton(() => GetAnnouncementsUseCase(getIt()));
  getIt.registerLazySingleton(() => CreateAnnouncementUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateAnnouncementUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteAnnouncementUseCase(getIt()));

  // Announcements - ViewModel
  getIt.registerFactory(() => AnnouncementViewModel(
    getAnnouncementsUseCase: getIt(),
    createAnnouncementUseCase: getIt(),
    updateAnnouncementUseCase: getIt(),
    deleteAnnouncementUseCase: getIt(),
  ));

  // Tasks - Remote Data Source
  getIt.registerLazySingleton(() => TaskRemoteDataSource(getIt<Dio>()));
  // Tasks - Repository
  getIt.registerLazySingleton(() => TaskRemoteRepository(getIt()));
  getIt.registerLazySingleton<TaskRepository>(() => getIt<TaskRemoteRepository>());
  // Tasks - Use Cases
  getIt.registerLazySingleton(() => GetMyTasksUseCase(getIt()));

  // Attendance - Remote Data Source
  getIt.registerLazySingleton(() => AttendanceRemoteDataSource(getIt<Dio>()));
  // Attendance - Repository
  getIt.registerLazySingleton(() => AttendanceRemoteRepository(getIt()));
  getIt.registerLazySingleton<AttendanceRepository>(() => getIt<AttendanceRemoteRepository>());
  // Attendance - Use Cases
  getIt.registerLazySingleton(() => GetMyAttendanceUseCase(getIt()));

  // Leaves - Remote Data Source
  getIt.registerLazySingleton(() => LeaveRemoteDataSource(getIt<Dio>()));
  // Leaves - Repository
  getIt.registerLazySingleton(() => LeaveRemoteRepository(getIt()));
  getIt.registerLazySingleton<LeaveRepository>(() => getIt<LeaveRemoteRepository>());
  // Leaves - Use Cases
}

Future<String?> getToken() async {
  final box = Hive.box<UserHiveModel>('userBox');
  final user = box.get('current_user');
  print('Token from Hive: ${user?.token}');
  return user?.token;
}

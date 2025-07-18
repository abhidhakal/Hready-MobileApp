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
import 'package:hready/features/employee/data/repositories/remote_repository/employee_remote_repository.dart';

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
import 'package:hready/features/tasks/domain/use_cases/get_all_tasks_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/create_task_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/update_task_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:hready/features/tasks/presentation/view_model/task_view_model.dart';
import 'package:hready/features/tasks/presentation/view_model/task_bloc.dart';
import 'package:hready/features/tasks/presentation/view_model/task_event.dart';
import 'package:hready/features/tasks/domain/use_cases/get_all_users_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/update_my_task_status_use_case.dart';

// Attendance
import 'package:hready/features/attendance/data/datasources/remote_datasource/attendance_remote_data_source.dart';
import 'package:hready/features/attendance/data/repositories/attendance_remote_repository.dart';
import 'package:hready/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:hready/features/attendance/domain/use_cases/get_my_attendance_use_case.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_bloc.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_event.dart';
import 'package:hready/features/attendance/domain/use_cases/mark_attendance_use_case.dart';
import 'package:hready/features/attendance/domain/use_cases/get_all_attendance_use_case.dart';

// Leaves
import 'package:hready/features/leaves/data/datasources/remote_datasource/leave_remote_data_source.dart';
import 'package:hready/features/leaves/data/repositories/leave_remote_repository.dart';
import 'package:hready/features/leaves/domain/repositories/leave_repository.dart';
import 'package:hready/features/leaves/presentation/view_model/leave_bloc.dart';
import 'package:hready/features/leaves/domain/use_cases/get_my_leaves_use_case.dart';

// Employee
import 'package:hready/features/employee/data/datasources/remote_datasource/employee_remote_data_source.dart';
import 'package:hready/features/employee/domain/repositories/employee_repository.dart';
import 'package:hready/features/employee/domain/use_cases/get_all_employees_use_case.dart';
import 'package:hready/features/employee/domain/use_cases/add_employee_use_case.dart';
import 'package:hready/features/employee/domain/use_cases/update_employee_use_case.dart';
import 'package:hready/features/employee/domain/use_cases/delete_employee_use_case.dart';
import 'package:hready/features/employee/presentation/view_model/employee_bloc.dart';
import 'package:hready/features/employee/domain/use_cases/get_employee_profile_use_case.dart';

// Requests
import 'package:hready/features/requests/data/datasources/remote_datasource/request_remote_data_source.dart';
import 'package:hready/features/requests/data/repositories/request_repository_impl.dart';
import 'package:hready/features/requests/domain/repositories/request_repository.dart';
import 'package:hready/features/requests/domain/use_cases/get_all_requests_use_case.dart';
import 'package:hready/features/requests/domain/use_cases/approve_request_use_case.dart';
import 'package:hready/features/requests/domain/use_cases/reject_request_use_case.dart';
import 'package:hready/features/requests/domain/use_cases/get_my_requests_use_case.dart';
import 'package:hready/features/requests/domain/use_cases/submit_request_use_case.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Hive box for caching UserEntity
  final userBox = await Hive.openBox<UserHiveModel>('userBox');

  // Core - ApiService with getToken from Hive
  getIt.registerLazySingleton(() => ApiService(
        'http://192.168.18.175:3000',
        getToken: () async {
          final model = userBox.get('current_user');
          return model?.token;
        },
      ));

  // Auth - Remote Datasource
  getIt.registerLazySingleton<IUserRemoteDatasource>(
    () => UserRemoteDatasource(getIt<Dio>()),
  );

  // Auth Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRemoteRepository(
      remoteDatasource: getIt<IUserRemoteDatasource>(),
      hiveBox: userBox,
    ),
  );

  // Auth Use Cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => GetCachedUserUseCase(getIt<AuthRepository>()));

  // Auth ViewModel
  getIt.registerFactory(() => AuthViewModel(
        loginUseCase: getIt(),
        registerUseCase: getIt(),
        getCachedUserUseCase: getIt(),
      ));

  // Splash ViewModel
  getIt.registerFactory(() => SplashViewModel(getCachedUserUseCase: getIt()));

  // Dashboards
  getIt.registerFactory(() => AdminDashboardViewModel());
  getIt.registerFactory(() => EmployeeDashboardViewModel());

  // Register Dio for API calls
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(baseUrl: 'http://192.168.18.175:3000/api'));
    // Optionally add an interceptor to always add the token
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await getToken();
        print('DIO REQUEST: ${options.method} ${options.path}');
        print('DIO HEADERS (before): ${options.headers}');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        print('DIO HEADERS (after): ${options.headers}');
        return handler.next(options);
      },
      onError: (DioError e, handler) {
        print('DIO ERROR: ${e.response?.statusCode} ${e.response?.data}');
        return handler.next(e);
      }
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
  getIt.registerLazySingleton(() => GetAnnouncementsUseCase(getIt<AnnouncementRepository>()));
  getIt.registerLazySingleton(() => CreateAnnouncementUseCase(getIt<AnnouncementRepository>()));
  getIt.registerLazySingleton(() => UpdateAnnouncementUseCase(getIt<AnnouncementRepository>()));
  getIt.registerLazySingleton(() => DeleteAnnouncementUseCase(getIt<AnnouncementRepository>()));
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
  getIt.registerLazySingleton(() => GetAllTasksUseCase(getIt<TaskRepository>()));
  getIt.registerLazySingleton(() => CreateTaskUseCase(getIt<TaskRepository>()));
  getIt.registerLazySingleton(() => UpdateTaskUseCase(getIt<TaskRepository>()));
  getIt.registerLazySingleton(() => DeleteTaskUseCase(getIt<TaskRepository>()));
  getIt.registerLazySingleton(() => GetAllUsersUseCase(getIt<IUserRemoteDatasource>()));
  getIt.registerLazySingleton(() => GetMyTasksUseCase(getIt<TaskRepository>()));
  getIt.registerLazySingleton(() => UpdateMyTaskStatusUseCase(getIt<TaskRepository>()));
  // Tasks - ViewModel
  getIt.registerFactory(() => TaskViewModel(
    getAllTasksUseCase: getIt(),
    createTaskUseCase: getIt(),
    updateTaskUseCase: getIt(),
    deleteTaskUseCase: getIt(),
    getAllUsersUseCase: getIt(),
    getMyTasksUseCase: getIt(),
  ));
  getIt.registerFactory(() => TaskBloc(
    getAllTasksUseCase: getIt(),
    getMyTasksUseCase: getIt(),
    createTaskUseCase: getIt(),
    updateTaskUseCase: getIt(),
    deleteTaskUseCase: getIt(),
    getAllUsersUseCase: getIt(),
    updateMyTaskStatusUseCase: getIt(),
  ));

  // Attendance - Remote Data Source
  getIt.registerLazySingleton(() => AttendanceRemoteDataSource(getIt<Dio>()));
  // Attendance - Repository
  getIt.registerLazySingleton(() => AttendanceRemoteRepository(getIt()));
  getIt.registerLazySingleton<AttendanceRepository>(() => getIt<AttendanceRemoteRepository>());
  // Attendance - Use Cases
  getIt.registerLazySingleton(() => GetMyAttendanceUseCase(getIt<AttendanceRepository>()));
  getIt.registerLazySingleton(() => MarkAttendanceUseCase(getIt<AttendanceRepository>()));
  getIt.registerLazySingleton(() => GetAllAttendanceUseCase(getIt<AttendanceRepository>()));
  getIt.registerFactory(() => AttendanceBloc(
    getMyAttendanceUseCase: getIt(),
    markAttendanceUseCase: getIt(),
    getAllAttendanceUseCase: getIt(),
  ));

  // Leaves - Remote Data Source
  getIt.registerLazySingleton(() => LeaveRemoteDataSource(getIt<Dio>()));
  getIt.registerLazySingleton(() => LeaveRemoteRepository(getIt()));
  getIt.registerLazySingleton<LeaveRepository>(() => getIt<LeaveRemoteRepository>());
  getIt.registerFactory(() => LeaveBloc(getIt<LeaveRepository>()));
  getIt.registerLazySingleton(() => GetMyLeavesUseCase(getIt<LeaveRepository>()));

  // Employee - Remote Data Source
  getIt.registerLazySingleton(() => EmployeeRemoteDataSource(getIt<Dio>()));
  final employeeToken = await getToken() ?? '';
  getIt.registerLazySingleton<IEmployeeRepository>(() => EmployeeRemoteRepository(
    baseUrl: 'http://192.168.18.175:3000/api',
    token: employeeToken,
  ));
  getIt.registerLazySingleton(() => GetAllEmployeesUseCase(getIt<IEmployeeRepository>()));
  getIt.registerLazySingleton(() => AddEmployeeUseCase(getIt<IEmployeeRepository>()));
  getIt.registerLazySingleton(() => UpdateEmployeeUseCase(getIt<IEmployeeRepository>()));
  getIt.registerLazySingleton(() => DeleteEmployeeUseCase(getIt<IEmployeeRepository>()));
  getIt.registerLazySingleton(() => GetEmployeeProfileUseCase(getIt<IEmployeeRepository>()));
  getIt.registerFactory(() => EmployeeBloc(
    getAllEmployeesUseCase: getIt(),
    addEmployeeUseCase: getIt(),
    updateEmployeeUseCase: getIt(),
    deleteEmployeeUseCase: getIt(),
  ));

  // Requests - Remote Data Source
  getIt.registerLazySingleton<RequestRemoteDataSource>(
    () => RequestRemoteDataSourceImpl(getIt<Dio>()),
  );
  // Requests - Repository
  getIt.registerLazySingleton<RequestRepository>(
    () => RequestRepositoryImpl(getIt<Dio>()),
  );
  // Requests - Use Cases
  getIt.registerLazySingleton(() => GetAllRequestsUseCase(getIt<RequestRepository>()));
  getIt.registerLazySingleton(() => ApproveRequestUseCase(getIt<RequestRepository>()));
  getIt.registerLazySingleton(() => RejectRequestUseCase(getIt<RequestRepository>()));
  getIt.registerLazySingleton(() => GetMyRequestsUseCase(getIt<RequestRepository>()));
  getIt.registerLazySingleton(() => SubmitRequestUseCase(getIt<RequestRepository>()));
}

Future<String?> getToken() async {
  final box = Hive.box<UserHiveModel>('userBox');
  final user = box.get('current_user');
  print('Token from Hive: ${user?.token}');
  return user?.token;
}

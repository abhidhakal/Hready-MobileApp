import 'package:get_it/get_it.dart';
import 'package:hready/core/network/hive_service.dart';
import 'package:hready/features/admin/data/datasources/local_datasource/admin_local_datasource.dart';
import 'package:hready/features/admin/data/repositories/local_repository/admin_local_repository.dart';
import 'package:hready/features/admin/domain/repositories/admin_repository.dart';
import 'package:hready/features/employee/data/datasources/local_datasource/employee_local_data_source.dart';
import 'package:hready/features/employee/data/repositories/local_repository/employee_local_repository.dart';
import 'package:hready/features/employee/domain/repositories/employee_repository.dart';

final serviceLocator = GetIt.instance;

Future<void> initLocator() async {
  // Blocs
  serviceLocator.registerFactory(
    () => AuthBloc(
      loginAdminUseCase: serviceLocator(),
      loginEmployeeUseCase: serviceLocator(),
      registerAdminUseCase: serviceLocator(),
      registerEmployeeUseCase: serviceLocator(),
    ),
  );

  // Use Cases
  serviceLocator.registerLazySingleton(() => LoginAdminUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => RegisterAdminUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => LoginEmployeeUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => RegisterEmployeeUseCase(serviceLocator()));


  // Repositories
  serviceLocator.registerLazySingleton<IAdminRepository>(
    () => AdminLocalRepository(adminLocalDatasource: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<IEmployeeRepository>(
        () => EmployeeLocalRepository(employeeLocalDatasource: serviceLocator()),
  );


  // Data Sources
  serviceLocator.registerLazySingleton(
    () => AdminLocalDatasource(hiveService: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
        () => EmployeeLocalDatasource(hiveService: serviceLocator()),
  );


  // External
  serviceLocator.registerLazySingleton(() => HiveService());
}
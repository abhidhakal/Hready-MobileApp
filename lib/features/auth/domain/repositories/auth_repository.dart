// class AuthRepository {
//   final HiveService hiveService;

//   AuthRepository(this.hiveService);

//   Future<(String, dynamic)> login(String email, String password) async {
//     try {
//       final admin = await hiveService.loginAdmin(email, password);
//       return ('admin', admin);
//     } catch (_) {}

//     try {
//       final employee = await hiveService.loginEmployee(email, password);
//       return ('employee', employee);
//     } catch (_) {}

//     throw Exception('Invalid credentials');
//   }

//   Future<void> registerAdmin(AdminHiveModel admin) async {
//     await hiveService.addAdmin(admin);
//   }

//   Future<void> registerEmployee(EmployeeHiveModel employee) async {
//     await hiveService.addEmployee(employee);
//   }
// }

import 'package:hready/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(Map<String, dynamic> payload);
  Future<UserEntity> getProfile(String token);
  Future<void> cacheUser(UserEntity user);
  Future<UserEntity?> getCachedUser();
}


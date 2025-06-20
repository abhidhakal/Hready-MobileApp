import 'package:hready/core/network/hive_service.dart';
import 'package:hready/features/admin/data/models/admin_hive_model.dart';
import 'package:hready/features/employee/data/models/employee_hive_model.dart';

class AuthRepository {
  final HiveService hiveService;

  AuthRepository(this.hiveService);

  Future<(String, dynamic)> login(String email, String password) async {
    try {
      final admin = await hiveService.loginAdmin(email, password);
      return ('admin', admin);
    } catch (_) {}

    try {
      final employee = await hiveService.loginEmployee(email, password);
      return ('employee', employee);
    } catch (_) {}

    throw Exception('Invalid credentials');
  }

  Future<void> registerAdmin(AdminHiveModel admin) async {
    await hiveService.addAdmin(admin);
  }

  Future<void> registerEmployee(EmployeeHiveModel employee) async {
    await hiveService.addEmployee(employee);
  }
}

import 'package:hready/core/network/hive_service.dart';
import 'package:hready/features/employee/data/datasources/employee_data_source.dart';
import 'package:hready/features/employee/data/models/employee_hive_model.dart';
import 'package:hready/features/employee/domain/entities/employee_entity.dart';

class EmployeeLocalDatasource implements IEmployeeDataSource {
  final HiveService _hiveService;

  EmployeeLocalDatasource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<void> addEmployee(EmployeeEntity employeeData) async {
    try {
      final employeeHiveModel = EmployeeHiveModel.fromEntity(employeeData);
      await _hiveService.addEmployee(employeeHiveModel);
    } catch (e) {
      throw Exception('Failed to add employee: $e');
    }
  }

  @override
  Future<EmployeeEntity?> loginEmployee(String email, String password) async {
    try {
      final employeeData = await _hiveService.loginEmployee(email, password);
      return employeeData?.toEntity();
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<EmployeeEntity?> getEmployee(String employeeId) async {
    try {
      final employeeData = await _hiveService.getEmployee(employeeId);
      return employeeData?.toEntity();
    } catch (e) {
      throw Exception('Failed to get employee: $e');
    }
  }

  @override
  Future<void> uploadProfilePicture(String employeeId, String imagePath) async {
    try {
      final employee = await _hiveService.getEmployee(employeeId);
      if (employee != null) {
        final updatedEmployee = EmployeeHiveModel(
          employeeId: employee.employeeId,
          name: employee.name,
          email: employee.email,
          password: employee.password,
          profilePicture: imagePath, // Update the profile picture path
          contactNo: employee.contactNo,
          role: employee.role,
          department: employee.department,
          position: employee.position,
        );
        await _hiveService.updateEmployee(updatedEmployee);
      } else {
        throw Exception('Employee not found');
      }
    } catch (e) {
      throw Exception('Failed to upload profile picture: $e');
    }
  }
}
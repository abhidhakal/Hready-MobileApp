import 'dart:io';

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
  Future<EmployeeEntity?> getEmployee() {
    throw UnimplementedError();
  }

  @override
  Future<void> uploadProfilePicture(File file) {
    throw UnimplementedError();
  }

  @override
  Future<List<EmployeeEntity>> getAllEmployees() async {
    // TODO: Implement actual fetching logic from HiveService
    return [];
  }
}
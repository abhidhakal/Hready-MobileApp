import 'package:hive_flutter/hive_flutter.dart';
import 'package:hready/app/constant/hive/hive_table_constant.dart';
import 'package:hready/features/admin/data/models/admin_hive_model.dart';
import 'package:hready/features/employee/data/models/employee_hive_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  Future<void> init() async {
    // initializing the local database
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path} hready.db';

    Hive.init(path);

    // register adapters
    Hive.registerAdapter(AdminHiveModelAdapter());
    Hive.registerAdapter(EmployeeHiveModelAdapter());
  }

  // Admin queries
  Future<void> addAdmin(AdminHiveModel admin) async {
    var box = await Hive.openBox<AdminHiveModel>(HiveTableConstant.adminBox);
    await box.put(admin.adminId, admin);
  }

  Future<void> deleteAdmin(String adminId) async {
    var box = await Hive.openBox<AdminHiveModel>(HiveTableConstant.adminBox);
    await box.delete(adminId);
  }

  // Admin Login
  Future<AdminHiveModel?> loginAdmin(String email, String password) async {
    var box = await Hive.openBox<AdminHiveModel>(HiveTableConstant.adminBox);
    var admin = box.values.firstWhere(
      (element) => element.email == email && element.password == password,
      orElse: () => throw Exception('Invalid username or password'),
    );
    box.close();
    return admin;
  }

  // Employee queries
  Future<void> addEmployee(EmployeeHiveModel employee) async {
    var box = await Hive.openBox<EmployeeHiveModel>(HiveTableConstant.employeeBox);
    await box.put(employee.employeeId, employee);
  }

  Future<void> updateEmployee(EmployeeHiveModel employee) async {
    var box = await Hive.openBox<EmployeeHiveModel>(HiveTableConstant.employeeBox);
    await box.put(employee.employeeId, employee);
  }

  Future<EmployeeHiveModel?> getEmployee(String employeeId) async {
    var box = await Hive.openBox<EmployeeHiveModel>(HiveTableConstant.employeeBox);
    return box.get(employeeId);
  }

  Future<void> deleteEmployee(String employeeId) async {
    var box = await Hive.openBox<EmployeeHiveModel>(HiveTableConstant.employeeBox);
    await box.delete(employeeId);
  }

  // Employee Login
  Future<EmployeeHiveModel?> loginEmployee(String email, String password) async {
    var box = await Hive.openBox<EmployeeHiveModel>(HiveTableConstant.employeeBox);
    var employee = box.values.firstWhere(
      (element) => element.email == email && element.password == password,
      orElse: () => throw Exception('Invalid username or password'),
    );
    box.close();
    return employee;
  }


  Future<void> clearAllData() async {
    await Hive.deleteFromDisk();
    await Hive.deleteBoxFromDisk(HiveTableConstant.adminBox);
    await Hive.deleteBoxFromDisk(HiveTableConstant.employeeBox);
  }

  Future<void> close() async {
    await Hive.close();
  }
}
import 'package:hready/features/employee/domain/entities/employee_entity.dart';

abstract interface class IEmployeeDataSource {
  Future<void> addEmployee(EmployeeEntity employeeData);
  Future<EmployeeEntity?> loginEmployee(String email, String password);
  Future<EmployeeEntity?> getEmployee(String employeeId);
  Future<void> uploadProfilePicture(String employeeId, String imagePath);
}
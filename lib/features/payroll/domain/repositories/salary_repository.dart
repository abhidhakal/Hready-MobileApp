import 'package:hready/features/payroll/domain/entities/salary.dart';

abstract class SalaryRepository {
  Future<List<Salary>> getAllSalaries();
  Future<Salary> getSalaryByEmployee(String employeeId);
  Future<List<Salary>> getSalaryHistory(String employeeId);
  Future<Salary> createSalary(Map<String, dynamic> salaryData);
  Future<Salary> updateSalary(String id, Map<String, dynamic> salaryData);
  Future<void> deleteSalary(String id);
  Future<Map<String, dynamic>> getSalaryStats();
} 
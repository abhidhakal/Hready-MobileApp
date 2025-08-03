import 'package:hready/features/payroll/domain/entities/salary.dart';
import 'package:hready/features/payroll/domain/repositories/salary_repository.dart';
import 'package:hready/features/payroll/data/datasources/salary_remote_data_source.dart';

class SalaryRepositoryImpl implements SalaryRepository {
  final SalaryRemoteDataSource remoteDataSource;

  SalaryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Salary>> getAllSalaries() async {
    try {
      final salaryModels = await remoteDataSource.getAllSalaries();
      return salaryModels.map((model) => model as Salary).toList();
    } catch (e) {
      throw Exception('Failed to get salaries: $e');
    }
  }

  @override
  Future<Salary> getSalaryByEmployee(String employeeId) async {
    try {
      final salaryModel = await remoteDataSource.getSalaryByEmployee(employeeId);
      return salaryModel as Salary;
    } catch (e) {
      throw Exception('Failed to get salary by employee: $e');
    }
  }

  @override
  Future<List<Salary>> getSalaryHistory(String employeeId) async {
    try {
      final salaryModels = await remoteDataSource.getSalaryHistory(employeeId);
      return salaryModels.map((model) => model as Salary).toList();
    } catch (e) {
      throw Exception('Failed to get salary history: $e');
    }
  }

  @override
  Future<Salary> createSalary(Map<String, dynamic> salaryData) async {
    try {
      final salaryModel = await remoteDataSource.createSalary(salaryData);
      return salaryModel as Salary;
    } catch (e) {
      throw Exception('Failed to create salary: $e');
    }
  }

  @override
  Future<Salary> updateSalary(String id, Map<String, dynamic> salaryData) async {
    try {
      final salaryModel = await remoteDataSource.updateSalary(id, salaryData);
      return salaryModel as Salary;
    } catch (e) {
      throw Exception('Failed to update salary: $e');
    }
  }

  @override
  Future<void> deleteSalary(String id) async {
    try {
      await remoteDataSource.deleteSalary(id);
    } catch (e) {
      throw Exception('Failed to delete salary: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getSalaryStats() async {
    try {
      return await remoteDataSource.getSalaryStats();
    } catch (e) {
      throw Exception('Failed to get salary stats: $e');
    }
  }
} 
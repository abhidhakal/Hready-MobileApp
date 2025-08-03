import 'package:dio/dio.dart';
import 'package:hready/features/payroll/data/models/salary_model.dart';
import 'package:hready/core/error/result.dart';
import 'package:hready/core/error/safe_executor.dart';

abstract class SalaryRemoteDataSource {
  Future<List<SalaryModel>> getAllSalaries();
  Future<SalaryModel> getSalaryByEmployee(String employeeId);
  Future<List<SalaryModel>> getSalaryHistory(String employeeId);
  Future<SalaryModel> createSalary(Map<String, dynamic> salaryData);
  Future<SalaryModel> updateSalary(String id, Map<String, dynamic> salaryData);
  Future<void> deleteSalary(String id);
  Future<Map<String, dynamic>> getSalaryStats();
}

class SalaryRemoteDataSourceImpl implements SalaryRemoteDataSource {
  final Dio dio;

  SalaryRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<SalaryModel>> getAllSalaries() async {
    return await SafeExecutor.executeAsync(() async {
      final response = await dio.get('/salaries');
      return (response.data as List).map((json) => SalaryModel.fromJson(json)).toList();
    }).then((result) => result.getOrThrow());
  }

  @override
  Future<SalaryModel> getSalaryByEmployee(String employeeId) async {
    return await SafeExecutor.executeAsync(() async {
      final response = await dio.get('/salaries/employee/$employeeId');
      return SalaryModel.fromJson(response.data);
    }).then((result) => result.getOrThrow());
  }

  @override
  Future<List<SalaryModel>> getSalaryHistory(String employeeId) async {
    return await SafeExecutor.executeAsync(() async {
      final response = await dio.get('/salaries/employee/$employeeId/history');
      return (response.data as List).map((json) => SalaryModel.fromJson(json)).toList();
    }).then((result) => result.getOrThrow());
  }

  @override
  Future<SalaryModel> createSalary(Map<String, dynamic> salaryData) async {
    return await SafeExecutor.executeAsync(() async {
      final response = await dio.post('/salaries', data: salaryData);
      return SalaryModel.fromJson(response.data);
    }).then((result) => result.getOrThrow());
  }

  @override
  Future<SalaryModel> updateSalary(String id, Map<String, dynamic> salaryData) async {
    return await SafeExecutor.executeAsync(() async {
      final response = await dio.put('/salaries/$id', data: salaryData);
      return SalaryModel.fromJson(response.data);
    }).then((result) => result.getOrThrow());
  }

  @override
  Future<void> deleteSalary(String id) async {
    await SafeExecutor.executeAsync(() async {
      await dio.delete('/salaries/$id');
    }).then((result) => result.getOrThrow());
  }

  @override
  Future<Map<String, dynamic>> getSalaryStats() async {
    return await SafeExecutor.executeAsync(() async {
      final response = await dio.get('/salaries/stats');
      return response.data;
    }).then((result) => result.getOrThrow());
  }
} 
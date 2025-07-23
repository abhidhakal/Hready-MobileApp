import 'package:dio/dio.dart';
import '../../models/salary_model.dart';

class SalaryRemoteDataSource {
  final Dio dio;
  SalaryRemoteDataSource(this.dio);

  Future<List<SalaryModel>> getAllSalaries() async {
    final response = await dio.get('/salaries');
    return (response.data as List).map((json) => SalaryModel.fromJson(json)).toList();
  }

  Future<SalaryModel> getSalaryByEmployee(String employeeId) async {
    final response = await dio.get('/salaries/employee/$employeeId');
    return SalaryModel.fromJson(response.data);
  }

  Future<SalaryModel> createSalary(SalaryModel salary) async {
    final response = await dio.post('/salaries', data: salary.toJson());
    return SalaryModel.fromJson(response.data);
  }

  Future<SalaryModel> updateSalary(String id, Map<String, dynamic> updateData) async {
    final response = await dio.put('/salaries/$id', data: updateData);
    return SalaryModel.fromJson(response.data);
  }

  Future<void> deleteSalary(String id) async {
    await dio.delete('/salaries/$id');
  }
} 
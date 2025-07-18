import 'package:dio/dio.dart';
import 'package:hready/features/employee/data/models/employee_model.dart';

class EmployeeRemoteDataSource {
  final Dio dio;
  EmployeeRemoteDataSource(this.dio);

  Future<List<EmployeeModel>> getAllEmployees() async {
    final response = await dio.get('/employees');
    return (response.data as List).map((json) => EmployeeModel.fromJson(json)).toList();
  }

  Future<EmployeeModel> addEmployee(EmployeeModel employee) async {
    final response = await dio.post('/employees', data: employee.toJson());
    return EmployeeModel.fromJson(response.data);
  }

  Future<EmployeeModel> updateEmployee(String id, EmployeeModel employee) async {
    final response = await dio.put('/employees/$id', data: employee.toJson());
    return EmployeeModel.fromJson(response.data);
  }

  Future<void> deleteEmployee(String id) async {
    await dio.delete('/employees/$id');
  }
} 
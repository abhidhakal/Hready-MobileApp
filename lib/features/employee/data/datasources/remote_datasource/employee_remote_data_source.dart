import 'package:dio/dio.dart';
import 'package:hready/features/employee/domain/entities/employee_entity.dart';

class EmployeeRemoteDataSource {
  final Dio dio;
  EmployeeRemoteDataSource(this.dio);

  Future<List<EmployeeEntity>> getAllEmployees() async {
    final response = await dio.get('/employees');
    return (response.data as List)
        .map((json) => EmployeeEntity(
              employeeId: json['employeeId'] ?? json['_id'],
              name: json['name'] ?? '',
              email: json['email'] ?? '',
              profilePicture: json['profilePicture'] ?? '',
              password: json['password'] ?? '',
              contactNo: json['contactNo'] ?? '',
              role: json['role'] ?? '',
              department: json['department'] ?? '',
              position: json['position'] ?? '',
            ))
        .toList();
  }
} 
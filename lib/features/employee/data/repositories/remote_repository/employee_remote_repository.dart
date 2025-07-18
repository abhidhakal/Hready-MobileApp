import 'dart:io';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:hready/core/common/failure.dart';
import 'package:hready/features/employee/data/models/employee_model.dart';
import 'package:hready/features/employee/domain/entities/employee_entity.dart';
import 'package:hready/features/employee/domain/repositories/employee_repository.dart';
import 'package:http/http.dart' as http;

class EmployeeRemoteRepository implements IEmployeeRepository {
  final String baseUrl;
  final String token;

  EmployeeRemoteRepository({required this.baseUrl, required this.token});

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  @override
  Future<Either<Failure, void>> addEmployee(EmployeeEntity employee) async {
    try {
      final model = EmployeeModel(
        employeeId: employee.employeeId,
        name: employee.name,
        email: employee.email,
        password: employee.password,
        profilePicture: employee.profilePicture,
        contactNo: employee.contactNo,
        role: employee.role,
        department: employee.department,
        position: employee.position,
        status: employee.status,
      );
      final response = await http.post(
        Uri.parse('$baseUrl/employees'),
        headers: _headers,
        body: jsonEncode(model.toJson()),
      );
      if (response.statusCode == 201) {
        return const Right(null);
      } else {
        return Left(RemoteDataBaseFailure(message: response.body));
      }
    } catch (e) {
      return Left(RemoteDataBaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, EmployeeEntity?>> loginEmployee(String email, String password) async {
    // Not implemented for remote
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, EmployeeEntity?>> getEmployee() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/employees/me'),
        headers: _headers,
      );
      print('EMPLOYEE PROFILE RESPONSE: ' + response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final employee = EmployeeModel.fromJson(data);
        return Right(employee);
      } else {
        return Left(RemoteDataBaseFailure(message: response.body));
      }
    } catch (e) {
      return Left(RemoteDataBaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> uploadProfilePicture(File file) async {
    // Not implemented for remote
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<EmployeeEntity>>> getAllEmployees() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/employees'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final employees = EmployeeModel.fromJsonList(data);
        return Right(employees);
      } else {
        return Left(RemoteDataBaseFailure(message: response.body));
      }
    } catch (e) {
      return Left(RemoteDataBaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateEmployee(String id, EmployeeEntity employee) async {
    try {
      final model = EmployeeModel(
        employeeId: employee.employeeId,
        name: employee.name,
        email: employee.email,
        password: employee.password,
        profilePicture: employee.profilePicture,
        contactNo: employee.contactNo,
        role: employee.role,
        department: employee.department,
        position: employee.position,
        status: employee.status,
      );
      final response = await http.put(
        Uri.parse('$baseUrl/employees/$id'),
        headers: _headers,
        body: jsonEncode(model.toJson()),
      );
      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(RemoteDataBaseFailure(message: response.body));
      }
    } catch (e) {
      return Left(RemoteDataBaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEmployee(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/employees/$id'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(RemoteDataBaseFailure(message: response.body));
      }
    } catch (e) {
      return Left(RemoteDataBaseFailure(message: e.toString()));
    }
  }
} 
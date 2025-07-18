import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hready/core/common/failure.dart';
import 'package:hready/features/employee/data/datasources/local_datasource/employee_local_data_source.dart';
import 'package:hready/features/employee/domain/entities/employee_entity.dart';
import 'package:hready/features/employee/domain/repositories/employee_repository.dart';

class EmployeeLocalRepository implements IEmployeeRepository {
  final EmployeeLocalDatasource _employeeLocalDatasource;

  EmployeeLocalRepository(
      {required EmployeeLocalDatasource employeeLocalDatasource})
      : _employeeLocalDatasource = employeeLocalDatasource;

  @override
  Future<Either<Failure, void>> addEmployee(EmployeeEntity employee) async {
    try {
      await _employeeLocalDatasource.addEmployee(employee);
      return Right(null);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: 'Failed to add employee: $e'));
    }
  }

  @override
  Future<Either<Failure, EmployeeEntity?>> loginEmployee(
      String email, String password) async {
    try {
      final result =
          await _employeeLocalDatasource.loginEmployee(email, password);
      return Right(result);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: 'Failed to login: $e'));
    }
  }

  @override
  Future<Either<Failure, EmployeeEntity?>> getEmployee() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<EmployeeEntity>>> getAllEmployees() async {
    try {
      final employees = await _employeeLocalDatasource.getAllEmployees();
      return Right(employees);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: 'Failed to fetch employees: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(
      File file){
        throw UnimplementedError();
  }
}
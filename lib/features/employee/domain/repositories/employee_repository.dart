import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hready/core/common/failure.dart';
import 'package:hready/features/employee/domain/entities/employee_entity.dart';

abstract interface class IEmployeeRepository {
  Future<Either<Failure, void>> addEmployee(EmployeeEntity employee);
  Future<Either<Failure, EmployeeEntity?>> loginEmployee(
      String email, String password);
  Future<Either<Failure, EmployeeEntity?>> getEmployee();
  Future<Either<Failure, void>> uploadProfilePicture(
      File file);
  Future<Either<Failure, List<EmployeeEntity>>> getAllEmployees();
  Future<Either<Failure, void>> updateEmployee(String id, EmployeeEntity employee);
  Future<Either<Failure, void>> deleteEmployee(String id);
}
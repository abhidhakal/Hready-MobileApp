import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hready/core/common/failure.dart';
import 'package:hready/features/admin/data/datasources/local_datasource/admin_local_datasource.dart';
import 'package:hready/features/admin/domain/entities/admin_entity.dart';
import 'package:hready/features/admin/domain/repositories/admin_repository.dart';

class AdminRemoteRepository implements IAdminRepository{
  final AdminLocalDatasource _adminLocalDatasource;

  AdminRemoteRepository({required AdminLocalDatasource adminLocalDatasource}) : _adminLocalDatasource = adminLocalDatasource;

  @override
  Future<Either<Failure, void>> addAdmin(AdminEntity admin) async {
    try {
      await _adminLocalDatasource.addAdmin(admin);
      return Right(null);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: 'Failed to register: $e'));
    }
  }

  @override
  Future<Either<Failure, AdminEntity>> getAdmin() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> loginAdmin(String email, String password) async {
    try {
      final result = await _adminLocalDatasource.loginAdmin(email, password);
      return Right(result);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: 'Failed to login: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) {
    throw UnimplementedError();
  }

}
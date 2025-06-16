import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hready/core/common/failure.dart';
import 'package:hready/features/admin/domain/entities/admin_entity.dart';

abstract interface class IAdminRepository {
  Future<Either<Failure, void>> addAdmin(AdminEntity admin);

  Future<Either<Failure, String>> loginAdmin(
    String email,
    String password,
  );

  Future<Either<Failure, String>> uploadProfilePicture(File file);

  Future<Either<Failure, AdminEntity>> getAdmin();
}
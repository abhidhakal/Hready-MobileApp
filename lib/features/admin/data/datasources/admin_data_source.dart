import 'dart:io';

import 'package:hready/features/admin/domain/entities/admin_entity.dart';

abstract interface class IAdminDataSource {
  Future<void> addAdmin(AdminEntity adminData);
  Future<String> loginAdmin(String email, String password);
  Future<String> uploadProfilePicture(File file);
  Future<AdminEntity> getAdmin();
}
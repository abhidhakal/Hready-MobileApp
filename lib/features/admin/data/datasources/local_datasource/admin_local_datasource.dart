import 'dart:io';

import 'package:hready/core/network/hive_service.dart';
import 'package:hready/features/admin/data/datasources/admin_data_source.dart';
import 'package:hready/features/admin/data/models/admin_hive_model.dart';
import 'package:hready/features/admin/domain/entities/admin_entity.dart';

class AdminLocalDatasource implements IAdminDataSource {
  final HiveService _hiveService;

  AdminLocalDatasource({required HiveService hiveService}) : _hiveService = hiveService;

  @override
  Future<void> addAdmin(AdminEntity adminData) async {
    try {
      final adminHiveModel = AdminHiveModel.fromEntity(adminData);
      await _hiveService.addAdmin(adminHiveModel);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<AdminEntity> getAdmin() {
    // TODO: implement getAdmin
    throw UnimplementedError();
  }

  @override
  Future<String> loginAdmin(String email, String password) async {
    try {
      final adminData = await _hiveService.loginAdmin(email, password);
      if (adminData != null && adminData.password == password) {
        return 'Login successful';
      } else {
        throw Exception('Invalid username or password');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) {
    // TODO: implement uploadProfilePicture
    throw UnimplementedError();
  }
}
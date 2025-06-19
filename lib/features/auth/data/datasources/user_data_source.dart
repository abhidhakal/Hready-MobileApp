import 'dart:io';

import 'package:hready/features/auth/domain/entities/user_entity.dart';

abstract interface class IUserDataSource {
  Future<void> addUser(UserEntity userData);
  Future<String> loginUser(String email, String password);
  Future<String> uploadProfilePicture(File file);
}
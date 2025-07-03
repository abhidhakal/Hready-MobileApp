import 'package:hready/features/auth/domain/entities/user_entity.dart';

abstract class IUserRemoteDatasource {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(Map<String, dynamic> payload);
  Future<UserEntity> getProfile(String token);
}

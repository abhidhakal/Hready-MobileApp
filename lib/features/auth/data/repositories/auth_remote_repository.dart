import 'package:hive/hive.dart';
import 'package:hready/features/auth/data/datasources/remote_datasource/user_remote_data_source.dart';
import 'package:hready/features/auth/data/models/user_hive_model.dart';
import 'package:hready/features/auth/domain/entities/user_entity.dart';
import 'package:hready/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final UserRemoteDatasource remoteDatasource;
  final Box<UserHiveModel> hiveBox;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.hiveBox,
  });

  @override
  Future<UserEntity> login(String email, String password) async {
    final user = await remoteDatasource.login(email, password);
    await cacheUser(user);
    return user;
  }

  @override
  Future<UserEntity> register(Map<String, dynamic> payload) async {
    final user = await remoteDatasource.register(payload);
    await cacheUser(user);
    return user;
  }

  @override
  Future<UserEntity> getProfile(String token) {
    return remoteDatasource.getProfile(token);
  }

  @override
  Future<void> cacheUser(UserEntity user) async {
    final model = UserHiveModel.fromEntity(user);
    await hiveBox.put('current_user', model);
  }

  @override
  Future<UserEntity?> getCachedUser() async {
    final model = hiveBox.get('current_user');
    return model?.toEntity();
  }
}

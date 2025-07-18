import 'package:dio/dio.dart';
import '../../../domain/entities/user_entity.dart';
import 'package:hready/features/auth/data/datasources/user_remote_data_source.dart';

class UserRemoteDatasource implements IUserRemoteDatasource {
  final Dio dio;

  UserRemoteDatasource(this.dio);

  @override
  Future<List<UserEntity>> getAllUsers() async {
    final response = await dio.get('/employees');
    return (response.data as List).map((u) => UserEntity.fromJson(u)).toList();
  }

  @override
  Future<UserEntity> login(String email, String password) async {
    final response = await dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return UserEntity.fromJson(response.data);
  }

  @override
  Future<UserEntity> register(Map<String, dynamic> payload) async {
    final response = await dio.post('/auth/register', data: payload);
    return UserEntity.fromJson(response.data);
  }

  @override
  Future<UserEntity> getProfile(String token) async {
    final response = await dio.get('/me', options: Options(headers: {
      'Authorization': 'Bearer $token',
    }));
    return UserEntity.fromJson(response.data);
  }
}

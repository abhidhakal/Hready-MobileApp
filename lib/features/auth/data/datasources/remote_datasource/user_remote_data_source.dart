import 'package:hready/core/network/api_service.dart';
import 'package:hready/features/auth/data/datasources/user_remote_data_source.dart';
import '../../../domain/entities/user_entity.dart';

class UserRemoteDatasource implements IUserRemoteDatasource {
  final ApiService apiService;

  UserRemoteDatasource(this.apiService);

  @override
  Future<UserEntity> login(String email, String password) async {
    final json = await apiService.post('/api/auth/login', {
      'email': email,
      'password': password,
    });

    return _parseUser(json);
  }

  @override
  Future<UserEntity> register(Map<String, dynamic> payload) async {
    final json = await apiService.post('/api/auth/register', payload);
    return _parseUser(json);
  }

  @override
  Future<UserEntity> getProfile(String token) async {
    final json = await apiService.get('/api/me', headers: {
      'Authorization': 'Bearer $token',
    });
    return _parseUser(json);
  }

  UserEntity _parseUser(Map<String, dynamic> json) {
  return UserEntity(
    userId: json['_id'],
    email: json['email'],
    name: json['name'],
    role: json['role'],
    profilePicture: json['profilePicture'],
    contactNo: json['contactNo'],
    department: json['department'],
    position: json['position'],
    dateOfJoining: json['date_of_joing'] != null
        ? DateTime.tryParse(json['date_of_joing'])
        : null,
    status: json['status'],
    token: json['token'],
  );
}

}

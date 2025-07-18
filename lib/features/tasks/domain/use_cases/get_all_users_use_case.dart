import 'package:hready/features/auth/domain/entities/user_entity.dart';
import 'package:hready/features/auth/data/datasources/user_remote_data_source.dart';

class GetAllUsersUseCase {
  final IUserRemoteDatasource userRemoteDatasource;
  GetAllUsersUseCase(this.userRemoteDatasource);

  Future<List<UserEntity>> call() async {
    return await userRemoteDatasource.getAllUsers();
  }
} 
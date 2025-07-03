import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class GetCachedUserUseCase {
  final AuthRepository repository;

  GetCachedUserUseCase(this.repository);

  Future<UserEntity?> call() {
    return repository.getCachedUser();
  }
}

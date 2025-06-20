import 'package:hready/features/admin/data/models/admin_hive_model.dart';
import 'package:hready/features/auth/domain/repositories/auth_repository.dart';

class RegisterAdminUseCase {
  final AuthRepository repository;

  RegisterAdminUseCase(this.repository);

  Future<void> call(AdminHiveModel admin) {
    return repository.registerAdmin(admin);
  }
}

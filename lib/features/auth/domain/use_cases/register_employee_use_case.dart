import 'package:hready/features/employee/data/models/employee_hive_model.dart';
import 'package:hready/features/auth/domain/repositories/auth_repository.dart';

class RegisterEmployeeUseCase {
  final AuthRepository repository;

  RegisterEmployeeUseCase(this.repository);

  Future<void> call(EmployeeHiveModel employee) {
    return repository.registerEmployee(employee);
  }
}

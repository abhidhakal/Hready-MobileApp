import '../entities/employee_entity.dart';
import '../repositories/employee_repository.dart';

class UpdateEmployeeUseCase {
  final IEmployeeRepository repository;
  UpdateEmployeeUseCase(this.repository);

  Future<void> call(String id, EmployeeEntity employee) async {
    final result = await repository.updateEmployee(id, employee);
    return result.fold((failure) => throw Exception(failure.message), (_) => null);
  }
} 
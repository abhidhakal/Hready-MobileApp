import '../entities/employee_entity.dart';
import '../repositories/employee_repository.dart';

class AddEmployeeUseCase {
  final IEmployeeRepository repository;
  AddEmployeeUseCase(this.repository);

  Future<void> call(EmployeeEntity employee) async {
    final result = await repository.addEmployee(employee);
    return result.fold((failure) => throw Exception(failure.message), (_) => null);
  }
} 
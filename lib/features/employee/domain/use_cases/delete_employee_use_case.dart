import '../repositories/employee_repository.dart';

class DeleteEmployeeUseCase {
  final IEmployeeRepository repository;
  DeleteEmployeeUseCase(this.repository);

  Future<void> call(String id) => repository.deleteEmployee(id);
} 
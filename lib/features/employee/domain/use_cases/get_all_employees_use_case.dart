import '../entities/employee_entity.dart';
import '../repositories/employee_repository.dart';

class GetAllEmployeesUseCase {
  final IEmployeeRepository repository;
  GetAllEmployeesUseCase(this.repository);

  Future<List<EmployeeEntity>> call() async {
    final result = await repository.getAllEmployees();
    return result.fold((failure) => throw Exception(failure.message), (list) => list);
  }
} 
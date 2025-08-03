import 'package:hready/features/payroll/domain/entities/salary.dart';
import 'package:hready/features/payroll/domain/repositories/salary_repository.dart';

class GetAllSalaries {
  final SalaryRepository repository;

  GetAllSalaries(this.repository);

  Future<List<Salary>> call() async {
    return await repository.getAllSalaries();
  }
} 
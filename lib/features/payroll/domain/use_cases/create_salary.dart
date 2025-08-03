import 'package:hready/features/payroll/domain/entities/salary.dart';
import 'package:hready/features/payroll/domain/repositories/salary_repository.dart';

class CreateSalary {
  final SalaryRepository repository;

  CreateSalary(this.repository);

  Future<Salary> call(Map<String, dynamic> salaryData) async {
    return await repository.createSalary(salaryData);
  }
} 
import 'package:hready/features/payroll/domain/entities/salary.dart';
import 'package:hready/features/payroll/domain/repositories/salary_repository.dart';

class GetSalaryByEmployee {
  final SalaryRepository repository;

  GetSalaryByEmployee(this.repository);

  Future<Salary> call(String employeeId) async {
    return await repository.getSalaryByEmployee(employeeId);
  }
} 
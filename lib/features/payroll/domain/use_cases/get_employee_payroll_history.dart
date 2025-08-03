import 'package:hready/features/payroll/domain/entities/payroll.dart';
import 'package:hready/features/payroll/domain/repositories/payroll_repository.dart';

class GetEmployeePayrollHistory {
  final PayrollRepository repository;

  GetEmployeePayrollHistory(this.repository);

  Future<List<Payroll>> call(String employeeId) async {
    return await repository.getEmployeePayrollHistory(employeeId);
  }
} 
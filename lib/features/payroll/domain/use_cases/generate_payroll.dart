import 'package:hready/features/payroll/domain/entities/payroll.dart';
import 'package:hready/features/payroll/domain/repositories/payroll_repository.dart';

class GeneratePayroll {
  final PayrollRepository repository;

  GeneratePayroll(this.repository);

  Future<Payroll> call(Map<String, dynamic> payrollData) async {
    return await repository.generatePayroll(payrollData);
  }
} 
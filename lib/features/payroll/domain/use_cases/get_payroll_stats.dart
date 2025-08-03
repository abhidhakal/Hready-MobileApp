import 'package:hready/features/payroll/domain/repositories/payroll_repository.dart';

class GetPayrollStats {
  final PayrollRepository repository;

  GetPayrollStats(this.repository);

  Future<Map<String, dynamic>> call() async {
    return await repository.getPayrollStats();
  }
} 
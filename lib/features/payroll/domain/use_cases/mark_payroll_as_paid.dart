import 'package:hready/features/payroll/domain/entities/payroll.dart';
import 'package:hready/features/payroll/domain/repositories/payroll_repository.dart';

class MarkPayrollAsPaid {
  final PayrollRepository repository;

  MarkPayrollAsPaid(this.repository);

  Future<Payroll> call(String id, Map<String, dynamic> paymentData) async {
    return await repository.markPayrollAsPaid(id, paymentData);
  }
} 
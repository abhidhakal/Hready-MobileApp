import 'package:hready/features/payroll/domain/entities/payroll.dart';
import 'package:hready/features/payroll/domain/repositories/payroll_repository.dart';

class ApprovePayroll {
  final PayrollRepository repository;

  ApprovePayroll(this.repository);

  Future<Payroll> call(String id) async {
    return await repository.approvePayroll(id);
  }
} 
import 'package:hready/features/payroll/domain/repositories/payroll_repository.dart';

class BulkApprovePayrolls {
  final PayrollRepository repository;

  BulkApprovePayrolls(this.repository);

  Future<void> call(List<String> payrollIds) async {
    return await repository.bulkApprovePayrolls(payrollIds);
  }
} 
import '../repositories/payroll_repository.dart';

class BulkApprovePayrollsUseCase {
  final PayrollRepository repository;
  BulkApprovePayrollsUseCase(this.repository);

  Future<dynamic> call({required int month, required int year}) {
    return repository.bulkApprovePayrolls(month: month, year: year);
  }
} 
import '../repositories/payroll_repository.dart';

class ApprovePayrollUseCase {
  final PayrollRepository repository;
  ApprovePayrollUseCase(this.repository);

  Future<dynamic> call(String id) {
    return repository.approvePayroll(id);
  }
} 
import '../repositories/payroll_repository.dart';

class UpdatePayrollUseCase {
  final PayrollRepository repository;
  UpdatePayrollUseCase(this.repository);

  Future<dynamic> call(String id, Map<String, dynamic> updateData) {
    return repository.updatePayroll(id, updateData);
  }
} 
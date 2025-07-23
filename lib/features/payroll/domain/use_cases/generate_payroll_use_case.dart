import '../repositories/payroll_repository.dart';

class GeneratePayrollUseCase {
  final PayrollRepository repository;
  GeneratePayrollUseCase(this.repository);

  Future<dynamic> call({required int month, required int year}) {
    return repository.generatePayroll(month: month, year: year);
  }
} 
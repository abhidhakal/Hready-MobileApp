import '../repositories/payroll_repository.dart';

class GetPayrollByIdUseCase {
  final PayrollRepository repository;
  GetPayrollByIdUseCase(this.repository);

  Future<dynamic> call(String id) {
    return repository.getPayrollById(id);
  }
} 
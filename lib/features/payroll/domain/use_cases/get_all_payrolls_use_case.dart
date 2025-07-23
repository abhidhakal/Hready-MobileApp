import '../repositories/payroll_repository.dart';

class GetAllPayrollsUseCase {
  final PayrollRepository repository;
  GetAllPayrollsUseCase(this.repository);

  Future<List<dynamic>> call({int? month, int? year, String? status}) {
    return repository.getAllPayrolls(month: month, year: year, status: status);
  }
} 
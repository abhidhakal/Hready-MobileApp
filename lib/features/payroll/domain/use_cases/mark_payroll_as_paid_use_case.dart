import '../repositories/payroll_repository.dart';

class MarkPayrollAsPaidUseCase {
  final PayrollRepository repository;
  MarkPayrollAsPaidUseCase(this.repository);

  Future<dynamic> call(String id, {DateTime? paymentDate, String? paymentMethod, String? transactionId}) {
    return repository.markPayrollAsPaid(id, paymentDate: paymentDate, paymentMethod: paymentMethod, transactionId: transactionId);
  }
} 
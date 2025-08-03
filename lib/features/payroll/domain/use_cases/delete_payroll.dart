import 'package:hready/features/payroll/domain/repositories/payroll_repository.dart';

class DeletePayroll {
  final PayrollRepository repository;

  DeletePayroll(this.repository);

  Future<void> call(String id) async {
    return await repository.deletePayroll(id);
  }
} 
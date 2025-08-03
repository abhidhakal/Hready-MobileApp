import 'package:hready/features/payroll/domain/entities/payroll.dart';
import 'package:hready/features/payroll/domain/repositories/payroll_repository.dart';

class GetAllPayrolls {
  final PayrollRepository repository;

  GetAllPayrolls(this.repository);

  Future<List<Payroll>> call() async {
    return await repository.getAllPayrolls();
  }
} 
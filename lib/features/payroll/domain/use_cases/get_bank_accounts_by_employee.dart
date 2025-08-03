import 'package:hready/features/payroll/domain/entities/bank_account.dart';
import 'package:hready/features/payroll/domain/repositories/bank_account_repository.dart';

class GetBankAccountsByEmployee {
  final BankAccountRepository repository;

  GetBankAccountsByEmployee(this.repository);

  Future<List<BankAccount>> call(String employeeId) async {
    return await repository.getBankAccountsByEmployee(employeeId);
  }
} 
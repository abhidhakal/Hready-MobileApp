import 'package:hready/features/payroll/domain/entities/bank_account.dart';
import 'package:hready/features/payroll/domain/repositories/bank_account_repository.dart';

class UpdateBankAccount {
  final BankAccountRepository repository;

  UpdateBankAccount(this.repository);

  Future<BankAccount> call(String id, Map<String, dynamic> bankAccountData) async {
    return await repository.updateBankAccount(id, bankAccountData);
  }
} 
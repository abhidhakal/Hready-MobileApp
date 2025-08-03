import 'package:hready/features/payroll/domain/entities/bank_account.dart';
import 'package:hready/features/payroll/domain/repositories/bank_account_repository.dart';

class CreateBankAccount {
  final BankAccountRepository repository;

  CreateBankAccount(this.repository);

  Future<BankAccount> call(Map<String, dynamic> bankAccountData) async {
    return await repository.createBankAccount(bankAccountData);
  }
} 
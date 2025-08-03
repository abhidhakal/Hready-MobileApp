import 'package:hready/features/payroll/domain/entities/bank_account.dart';

abstract class BankAccountRepository {
  Future<List<BankAccount>> getAllBankAccounts();
  Future<List<BankAccount>> getBankAccountsByEmployee(String employeeId);
  Future<BankAccount> createBankAccount(Map<String, dynamic> bankAccountData);
  Future<BankAccount> updateBankAccount(String id, Map<String, dynamic> bankAccountData);
  Future<void> deleteBankAccount(String id);
  Future<BankAccount> setDefaultBankAccount(String id);
} 
import 'package:hready/features/payroll/domain/entities/bank_account.dart';
import 'package:hready/features/payroll/domain/repositories/bank_account_repository.dart';
import 'package:hready/features/payroll/data/datasources/bank_account_remote_data_source.dart';
import 'package:hready/features/payroll/data/models/bank_account_model.dart';

class BankAccountRepositoryImpl implements BankAccountRepository {
  final BankAccountRemoteDataSource remoteDataSource;

  BankAccountRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<BankAccount>> getAllBankAccounts() async {
    final bankAccountModels = await remoteDataSource.getAllBankAccounts();
    return bankAccountModels.map((model) => model as BankAccount).toList();
  }

  @override
  Future<List<BankAccount>> getBankAccountsByEmployee(String employeeId) async {
    final bankAccountModels = await remoteDataSource.getBankAccountsByEmployee(employeeId);
    return bankAccountModels.map((model) => model as BankAccount).toList();
  }

  @override
  Future<BankAccount> createBankAccount(Map<String, dynamic> bankAccountData) async {
    final bankAccountModel = await remoteDataSource.createBankAccount(bankAccountData);
    return bankAccountModel as BankAccount;
  }

  @override
  Future<BankAccount> updateBankAccount(String id, Map<String, dynamic> bankAccountData) async {
    final bankAccountModel = await remoteDataSource.updateBankAccount(id, bankAccountData);
    return bankAccountModel as BankAccount;
  }

  @override
  Future<void> deleteBankAccount(String id) async {
    await remoteDataSource.deleteBankAccount(id);
  }

  @override
  Future<BankAccount> setDefaultBankAccount(String id) async {
    final bankAccountModel = await remoteDataSource.setDefaultBankAccount(id);
    return bankAccountModel as BankAccount;
  }
} 
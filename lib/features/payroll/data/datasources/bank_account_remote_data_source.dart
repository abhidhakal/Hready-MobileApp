import 'package:dio/dio.dart';
import 'package:hready/features/payroll/data/models/bank_account_model.dart';
import 'package:hready/core/error/safe_executor.dart';

abstract class BankAccountRemoteDataSource {
  Future<List<BankAccountModel>> getAllBankAccounts();
  Future<List<BankAccountModel>> getBankAccountsByEmployee(String employeeId);
  Future<BankAccountModel> createBankAccount(Map<String, dynamic> bankAccountData);
  Future<BankAccountModel> updateBankAccount(String id, Map<String, dynamic> bankAccountData);
  Future<void> deleteBankAccount(String id);
  Future<BankAccountModel> setDefaultBankAccount(String id);
}

class BankAccountRemoteDataSourceImpl implements BankAccountRemoteDataSource {
  final Dio dio;

  BankAccountRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<BankAccountModel>> getAllBankAccounts() async {
    return await SafeExecutor.executeAsync(() async {
      final response = await dio.get('/bank-accounts');
      return (response.data as List).map((json) => BankAccountModel.fromJson(json)).toList();
    }).then((result) => result.getOrThrow());
  }

  @override
  Future<List<BankAccountModel>> getBankAccountsByEmployee(String employeeId) async {
    return await SafeExecutor.executeAsync(() async {
      final response = await dio.get('/bank-accounts/employee/$employeeId');
      return (response.data as List).map((json) => BankAccountModel.fromJson(json)).toList();
    }).then((result) => result.getOrThrow());
  }

  @override
  Future<BankAccountModel> createBankAccount(Map<String, dynamic> bankAccountData) async {
    return await SafeExecutor.executeAsync(() async {
      final response = await dio.post('/bank-accounts', data: bankAccountData);
      return BankAccountModel.fromJson(response.data);
    }).then((result) => result.getOrThrow());
  }

  @override
  Future<BankAccountModel> updateBankAccount(String id, Map<String, dynamic> bankAccountData) async {
    return await SafeExecutor.executeAsync(() async {
      final response = await dio.put('/bank-accounts/$id', data: bankAccountData);
      return BankAccountModel.fromJson(response.data);
    }).then((result) => result.getOrThrow());
  }

  @override
  Future<void> deleteBankAccount(String id) async {
    return await SafeExecutor.executeAsync(() async {
      await dio.delete('/bank-accounts/$id');
    }).then((result) => result.getOrThrow());
  }

  @override
  Future<BankAccountModel> setDefaultBankAccount(String id) async {
    return await SafeExecutor.executeAsync(() async {
      final response = await dio.put('/bank-accounts/$id/set-default');
      return BankAccountModel.fromJson(response.data);
    }).then((result) => result.getOrThrow());
  }
} 
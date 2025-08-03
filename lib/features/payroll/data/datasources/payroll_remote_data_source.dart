import 'package:dio/dio.dart';
import 'package:hready/core/network/api_base.dart';
import 'package:hready/features/payroll/data/models/payroll_model.dart';
import 'package:hready/core/error/result.dart';
import 'package:hready/core/error/safe_executor.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PayrollRemoteDataSource {
  Future<List<PayrollModel>> getAllPayrolls();
  Future<PayrollModel> getPayrollById(String id);
  Future<List<PayrollModel>> getEmployeePayrollHistory(String employeeId);
  Future<PayrollModel> generatePayroll(Map<String, dynamic> payrollData);
  Future<PayrollModel> updatePayroll(String id, Map<String, dynamic> payrollData);
  Future<PayrollModel> approvePayroll(String id);
  Future<PayrollModel> markPayrollAsPaid(String id, Map<String, dynamic> paymentData);
  Future<Map<String, dynamic>> getPayrollStats();
  Future<void> deletePayroll(String id);
  Future<void> bulkApprovePayrolls(List<String> payrollIds);
}

class PayrollRemoteDataSourceImpl implements PayrollRemoteDataSource {
  final Dio dio;

  PayrollRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PayrollModel>> getAllPayrolls() async {
    return await SafeExecutor.executeAsync(() async {
      final response = await dio.get('/payrolls');
      return (response.data as List).map((json) => PayrollModel.fromJson(json)).toList();
    }).then((result) => result.getOrThrow());
  }

  @override
  Future<PayrollModel> getPayrollById(String id) async {
    return await SafeExecutor.executeAsync(() async {
      final response = await dio.get('/payrolls/$id');
      return PayrollModel.fromJson(response.data);
    }).then((result) => result.getOrThrow());
  }

  @override
  Future<List<PayrollModel>> getEmployeePayrollHistory(String employeeId) async {
    final response = await dio.get('/payrolls/employee/$employeeId/history');
    return (response.data as List).map((json) => PayrollModel.fromJson(json)).toList();
  }

  @override
  Future<PayrollModel> generatePayroll(Map<String, dynamic> payrollData) async {
    return await SafeExecutor.executeAsync(() async {
      final response = await dio.post('/payrolls/generate', data: payrollData);
      return PayrollModel.fromJson(response.data);
    }).then((result) => result.getOrThrow());
  }

  @override
  Future<PayrollModel> updatePayroll(String id, Map<String, dynamic> payrollData) async {
    final response = await dio.put('/payrolls/$id', data: payrollData);
    return PayrollModel.fromJson(response.data);
  }

  @override
  Future<PayrollModel> approvePayroll(String id) async {
    final response = await dio.put('/payrolls/$id/approve');
    return PayrollModel.fromJson(response.data);
  }

  @override
  Future<PayrollModel> markPayrollAsPaid(String id, Map<String, dynamic> paymentData) async {
    final response = await dio.put('/payrolls/$id/mark-paid', data: paymentData);
    return PayrollModel.fromJson(response.data);
  }

  @override
  Future<Map<String, dynamic>> getPayrollStats() async {
    final response = await dio.get('/payrolls/stats');
    return response.data;
  }

  @override
  Future<void> deletePayroll(String id) async {
    await dio.delete('/payrolls/$id');
  }

  @override
  Future<void> bulkApprovePayrolls(List<String> payrollIds) async {
    await dio.put('/payrolls/bulk-approve', data: {'payrollIds': payrollIds});
  }
} 
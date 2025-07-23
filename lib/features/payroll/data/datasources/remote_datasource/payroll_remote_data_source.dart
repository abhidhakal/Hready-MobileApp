import '../../models/payroll_model.dart';

abstract class PayrollRemoteDataSource {
  Future<List<PayrollModel>> getAllPayrolls({int? month, int? year, String? status});
  Future<PayrollModel> getPayrollById(String id);
  Future<List<PayrollModel>> getEmployeePayrollHistory(String employeeId);
  Future<List<PayrollModel>> generatePayroll({required int month, required int year});
  Future<PayrollModel> updatePayroll(String id, Map<String, dynamic> updateData);
  Future<PayrollModel> approvePayroll(String id);
  Future<PayrollModel> markPayrollAsPaid(String id, {DateTime? paymentDate, String? paymentMethod, String? transactionId});
  Future<void> deletePayroll(String id);
  Future<Map<String, dynamic>> getPayrollStats({int? year});
  Future<Map<String, dynamic>> bulkApprovePayrolls({required int month, required int year});
} 
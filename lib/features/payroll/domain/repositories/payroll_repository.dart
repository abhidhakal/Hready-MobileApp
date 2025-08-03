import 'package:hready/features/payroll/domain/entities/payroll.dart';

abstract class PayrollRepository {
  Future<List<Payroll>> getAllPayrolls();
  Future<Payroll> getPayrollById(String id);
  Future<List<Payroll>> getEmployeePayrollHistory(String employeeId);
  Future<Payroll> generatePayroll(Map<String, dynamic> payrollData);
  Future<Payroll> updatePayroll(String id, Map<String, dynamic> payrollData);
  Future<Payroll> approvePayroll(String id);
  Future<Payroll> markPayrollAsPaid(String id, Map<String, dynamic> paymentData);
  Future<Map<String, dynamic>> getPayrollStats();
  Future<void> deletePayroll(String id);
  Future<void> bulkApprovePayrolls(List<String> payrollIds);
} 
abstract class PayrollRepository {
  // Define methods for fetching, creating, updating, and deleting payrolls
  Future<List<dynamic>> getAllPayrolls({int? month, int? year, String? status});
  Future<dynamic> getPayrollById(String id);
  Future<List<dynamic>> getEmployeePayrollHistory(String employeeId);
  Future<dynamic> generatePayroll({required int month, required int year});
  Future<dynamic> updatePayroll(String id, Map<String, dynamic> updateData);
  Future<dynamic> approvePayroll(String id);
  Future<dynamic> markPayrollAsPaid(String id, {DateTime? paymentDate, String? paymentMethod, String? transactionId});
  Future<dynamic> deletePayroll(String id);
  Future<Map<String, dynamic>> getPayrollStats({int? year});
  Future<dynamic> bulkApprovePayrolls({required int month, required int year});
} 
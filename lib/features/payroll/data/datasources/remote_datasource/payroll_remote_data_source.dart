import '../../models/payroll_model.dart';
import 'package:dio/dio.dart';

class PayrollRemoteDataSource {
  final Dio dio;
  PayrollRemoteDataSource(this.dio);

  Future<List<PayrollModel>> getAllPayrolls({int? month, int? year, String? status}) async {
    final queryParams = <String, dynamic>{};
    if (month != null) queryParams['month'] = month;
    if (year != null) queryParams['year'] = year;
    if (status != null) queryParams['status'] = status;
    final response = await dio.get('/payrolls', queryParameters: queryParams);
    return (response.data as List).map((json) => PayrollModel.fromJson(json)).toList();
  }

  Future<PayrollModel> getPayrollById(String id) async {
    final response = await dio.get('/payrolls/$id');
    return PayrollModel.fromJson(response.data);
  }

  Future<List<PayrollModel>> getEmployeePayrollHistory(String employeeId) async {
    final response = await dio.get('/payrolls/employee/$employeeId/history');
    return (response.data as List).map((json) => PayrollModel.fromJson(json)).toList();
  }

  Future<List<PayrollModel>> generatePayroll({required int month, required int year}) async {
    final response = await dio.post('/payrolls/generate', data: {'month': month, 'year': year});
    if (response.data is Map && response.data.containsKey('payrolls')) {
      final data = response.data['payrolls'] ?? [];
      return (data as List).map((json) => PayrollModel.fromJson(json)).toList();
    } else {
      // Optionally log the response for debugging
      print('Unexpected response from /payrolls/generate: ${response.data}');
      throw Exception('Failed to generate payroll: ${response.data is Map && response.data['message'] != null ? response.data['message'] : 'Unknown error'}');
    }
  }

  Future<PayrollModel> updatePayroll(String id, Map<String, dynamic> updateData) async {
    final response = await dio.put('/payrolls/$id', data: updateData);
    return PayrollModel.fromJson(response.data);
  }

  Future<PayrollModel> approvePayroll(String id) async {
    final response = await dio.put('/payrolls/$id/approve');
    return PayrollModel.fromJson(response.data);
  }

  Future<PayrollModel> markPayrollAsPaid(String id, {DateTime? paymentDate, String? paymentMethod, String? transactionId}) async {
    final data = <String, dynamic>{};
    if (paymentDate != null) data['paymentDate'] = paymentDate.toIso8601String();
    if (paymentMethod != null) data['paymentMethod'] = paymentMethod;
    if (transactionId != null) data['transactionId'] = transactionId;
    final response = await dio.put('/payrolls/$id/mark-paid', data: data);
    return PayrollModel.fromJson(response.data);
  }

  Future<void> deletePayroll(String id) async {
    await dio.delete('/payrolls/$id');
  }

  Future<Map<String, dynamic>> getPayrollStats({int? year}) async {
    final queryParams = <String, dynamic>{};
    if (year != null) queryParams['year'] = year;
    final response = await dio.get('/payrolls/stats', queryParameters: queryParams);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> bulkApprovePayrolls({required int month, required int year}) async {
    final response = await dio.put('/payroll/bulk-approve', data: {'month': month, 'year': year});
    return response.data as Map<String, dynamic>;
  }
} 
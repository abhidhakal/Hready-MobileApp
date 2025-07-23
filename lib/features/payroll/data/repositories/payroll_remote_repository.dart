import '../../domain/entities/payroll_entity.dart';
import '../../domain/repositories/payroll_repository.dart';
import '../datasources/remote_datasource/payroll_remote_data_source.dart';
import '../models/payroll_model.dart';

class PayrollRemoteRepository implements PayrollRepository {
  final PayrollRemoteDataSource remoteDataSource;
  PayrollRemoteRepository(this.remoteDataSource);

  @override
  Future<List<dynamic>> getAllPayrolls({int? month, int? year, String? status}) async {
    return await remoteDataSource.getAllPayrolls(month: month, year: year, status: status);
  }

  @override
  Future<dynamic> getPayrollById(String id) async {
    return await remoteDataSource.getPayrollById(id);
  }

  @override
  Future<List<dynamic>> getEmployeePayrollHistory(String employeeId) async {
    return await remoteDataSource.getEmployeePayrollHistory(employeeId);
  }

  @override
  Future<dynamic> generatePayroll({required int month, required int year}) async {
    return await remoteDataSource.generatePayroll(month: month, year: year);
  }

  @override
  Future<dynamic> updatePayroll(String id, Map<String, dynamic> updateData) async {
    return await remoteDataSource.updatePayroll(id, updateData);
  }

  @override
  Future<dynamic> approvePayroll(String id) async {
    return await remoteDataSource.approvePayroll(id);
  }

  @override
  Future<dynamic> markPayrollAsPaid(String id, {DateTime? paymentDate, String? paymentMethod, String? transactionId}) async {
    return await remoteDataSource.markPayrollAsPaid(id, paymentDate: paymentDate, paymentMethod: paymentMethod, transactionId: transactionId);
  }

  @override
  Future<dynamic> deletePayroll(String id) async {
    await remoteDataSource.deletePayroll(id);
  }

  @override
  Future<Map<String, dynamic>> getPayrollStats({int? year}) async {
    return await remoteDataSource.getPayrollStats(year: year);
  }

  @override
  Future<dynamic> bulkApprovePayrolls({required int month, required int year}) async {
    return await remoteDataSource.bulkApprovePayrolls(month: month, year: year);
  }
} 
import 'package:hready/features/payroll/domain/entities/payroll.dart';
import 'package:hready/features/payroll/domain/repositories/payroll_repository.dart';
import 'package:hready/features/payroll/data/datasources/payroll_remote_data_source.dart';

class PayrollRepositoryImpl implements PayrollRepository {
  final PayrollRemoteDataSource remoteDataSource;

  PayrollRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Payroll>> getAllPayrolls() async {
    try {
      final payrollModels = await remoteDataSource.getAllPayrolls();
      return payrollModels;
    } catch (e) {
      throw Exception('Failed to get payrolls: $e');
    }
  }

  @override
  Future<Payroll> getPayrollById(String id) async {
    try {
      final payrollModel = await remoteDataSource.getPayrollById(id);
      return payrollModel;
    } catch (e) {
      throw Exception('Failed to get payroll: $e');
    }
  }

  @override
  Future<List<Payroll>> getEmployeePayrollHistory(String employeeId) async {
    try {
      final payrollModels = await remoteDataSource.getEmployeePayrollHistory(employeeId);
      return payrollModels;
    } catch (e) {
      throw Exception('Failed to get payroll history: $e');
    }
  }

  @override
  Future<Payroll> generatePayroll(Map<String, dynamic> payrollData) async {
    try {
      final payrollModel = await remoteDataSource.generatePayroll(payrollData);
      return payrollModel;
    } catch (e) {
      throw Exception('Failed to generate payroll: $e');
    }
  }

  @override
  Future<Payroll> updatePayroll(String id, Map<String, dynamic> payrollData) async {
    try {
      final payrollModel = await remoteDataSource.updatePayroll(id, payrollData);
      return payrollModel;
    } catch (e) {
      throw Exception('Failed to update payroll: $e');
    }
  }

  @override
  Future<Payroll> approvePayroll(String id) async {
    try {
      final payrollModel = await remoteDataSource.approvePayroll(id);
      return payrollModel;
    } catch (e) {
      throw Exception('Failed to approve payroll: $e');
    }
  }

  @override
  Future<Payroll> markPayrollAsPaid(String id, Map<String, dynamic> paymentData) async {
    try {
      final payrollModel = await remoteDataSource.markPayrollAsPaid(id, paymentData);
      return payrollModel;
    } catch (e) {
      throw Exception('Failed to mark payroll as paid: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getPayrollStats() async {
    try {
      final stats = await remoteDataSource.getPayrollStats();
      return stats;
    } catch (e) {
      throw Exception('Failed to get payroll stats: $e');
    }
  }

  @override
  Future<void> deletePayroll(String id) async {
    try {
      await remoteDataSource.deletePayroll(id);
    } catch (e) {
      throw Exception('Failed to delete payroll: $e');
    }
  }

  @override
  Future<void> bulkApprovePayrolls(List<String> payrollIds) async {
    try {
      await remoteDataSource.bulkApprovePayrolls(payrollIds);
    } catch (e) {
      throw Exception('Failed to bulk approve payrolls: $e');
    }
  }
} 
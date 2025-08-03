import 'package:equatable/equatable.dart';
import 'package:hready/features/payroll/domain/entities/payroll.dart';

abstract class PayrollEvent extends Equatable {
  const PayrollEvent();

  @override
  List<Object?> get props => [];
}

class LoadPayrolls extends PayrollEvent {
  const LoadPayrolls();
}

class LoadEmployeePayrollHistory extends PayrollEvent {
  final String employeeId;

  const LoadEmployeePayrollHistory(this.employeeId);

  @override
  List<Object?> get props => [employeeId];
}

class GeneratePayroll extends PayrollEvent {
  final Map<String, dynamic> payrollData;

  const GeneratePayroll(this.payrollData);

  @override
  List<Object?> get props => [payrollData];
}

class ApprovePayroll extends PayrollEvent {
  final String payrollId;

  const ApprovePayroll(this.payrollId);

  @override
  List<Object?> get props => [payrollId];
}

class MarkPayrollAsPaid extends PayrollEvent {
  final String payrollId;
  final Map<String, dynamic> paymentData;

  const MarkPayrollAsPaid(this.payrollId, this.paymentData);

  @override
  List<Object?> get props => [payrollId, paymentData];
}

class LoadPayrollStats extends PayrollEvent {
  const LoadPayrollStats();
}

class BulkApprovePayrolls extends PayrollEvent {
  final List<String> payrollIds;

  const BulkApprovePayrolls(this.payrollIds);

  @override
  List<Object?> get props => [payrollIds];
}

class DeletePayroll extends PayrollEvent {
  final String payrollId;

  const DeletePayroll(this.payrollId);

  @override
  List<Object?> get props => [payrollId];
} 
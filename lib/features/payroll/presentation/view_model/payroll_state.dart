import 'package:equatable/equatable.dart';
import 'package:hready/features/payroll/domain/entities/payroll.dart';

abstract class PayrollState extends Equatable {
  const PayrollState();

  @override
  List<Object?> get props => [];
}

class PayrollInitial extends PayrollState {}

class PayrollLoading extends PayrollState {}

class PayrollsLoaded extends PayrollState {
  final List<Payroll> payrolls;

  const PayrollsLoaded(this.payrolls);

  @override
  List<Object?> get props => [payrolls];
}

class EmployeePayrollHistoryLoaded extends PayrollState {
  final List<Payroll> payrolls;

  const EmployeePayrollHistoryLoaded(this.payrolls);

  @override
  List<Object?> get props => [payrolls];
}

class PayrollGenerated extends PayrollState {
  final Payroll payroll;

  const PayrollGenerated(this.payroll);

  @override
  List<Object?> get props => [payroll];
}

class PayrollApproved extends PayrollState {
  final Payroll payroll;

  const PayrollApproved(this.payroll);

  @override
  List<Object?> get props => [payroll];
}

class PayrollMarkedAsPaid extends PayrollState {
  final Payroll payroll;

  const PayrollMarkedAsPaid(this.payroll);

  @override
  List<Object?> get props => [payroll];
}

class PayrollStatsLoaded extends PayrollState {
  final Map<String, dynamic> stats;

  const PayrollStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class PayrollsBulkApproved extends PayrollState {
  final List<String> approvedIds;

  const PayrollsBulkApproved(this.approvedIds);

  @override
  List<Object?> get props => [approvedIds];
}

class PayrollDeleted extends PayrollState {
  final String deletedId;

  const PayrollDeleted(this.deletedId);

  @override
  List<Object?> get props => [deletedId];
}

class PayrollError extends PayrollState {
  final String message;

  const PayrollError(this.message);

  @override
  List<Object?> get props => [message];
} 
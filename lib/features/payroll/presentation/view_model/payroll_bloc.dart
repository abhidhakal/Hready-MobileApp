import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/payroll/domain/use_cases/get_all_payrolls.dart';
import 'package:hready/features/payroll/domain/use_cases/get_employee_payroll_history.dart';
import 'package:hready/features/payroll/domain/use_cases/generate_payroll.dart' as generate_use_case;
import 'package:hready/features/payroll/domain/use_cases/approve_payroll.dart' as approve_use_case;
import 'package:hready/features/payroll/domain/use_cases/mark_payroll_as_paid.dart' as mark_paid_use_case;
import 'package:hready/features/payroll/domain/use_cases/get_payroll_stats.dart';
import 'package:hready/features/payroll/domain/use_cases/bulk_approve_payrolls.dart' as bulk_approve_use_case;
import 'package:hready/features/payroll/domain/use_cases/delete_payroll.dart' as delete_use_case;
import 'package:hready/features/payroll/presentation/view_model/payroll_event.dart';
import 'package:hready/features/payroll/presentation/view_model/payroll_state.dart';
import 'package:hready/core/error/error_handler.dart';

class PayrollBloc extends Bloc<PayrollEvent, PayrollState> {
  final GetAllPayrolls getAllPayrolls;
  final GetEmployeePayrollHistory getEmployeePayrollHistory;
  final generate_use_case.GeneratePayroll generatePayroll;
  final approve_use_case.ApprovePayroll approvePayroll;
  final mark_paid_use_case.MarkPayrollAsPaid markPayrollAsPaid;
  final GetPayrollStats getPayrollStats;
  final bulk_approve_use_case.BulkApprovePayrolls bulkApprovePayrolls;
  final delete_use_case.DeletePayroll deletePayroll;

  PayrollBloc({
    required this.getAllPayrolls,
    required this.getEmployeePayrollHistory,
    required this.generatePayroll,
    required this.approvePayroll,
    required this.markPayrollAsPaid,
    required this.getPayrollStats,
    required this.bulkApprovePayrolls,
    required this.deletePayroll,
  }) : super(PayrollInitial()) {
    on<LoadPayrolls>(_onLoadPayrolls);
    on<LoadEmployeePayrollHistory>(_onLoadEmployeePayrollHistory);
    on<GeneratePayroll>(_onGeneratePayroll);
    on<ApprovePayroll>(_onApprovePayroll);
    on<MarkPayrollAsPaid>(_onMarkPayrollAsPaid);
    on<LoadPayrollStats>(_onLoadPayrollStats);
    on<BulkApprovePayrolls>(_onBulkApprovePayrolls);
    on<DeletePayroll>(_onDeletePayroll);
  }

  Future<void> _onLoadPayrolls(LoadPayrolls event, Emitter<PayrollState> emit) async {
    emit(PayrollLoading());
    try {
      final payrolls = await getAllPayrolls();
      emit(PayrollsLoaded(payrolls));
    } catch (e) {
      final exception = ErrorHandler.handle(e);
      ErrorHandler.logError(exception);
      emit(PayrollError(exception.message));
    }
  }

  Future<void> _onLoadEmployeePayrollHistory(LoadEmployeePayrollHistory event, Emitter<PayrollState> emit) async {
    emit(PayrollLoading());
    try {
      final payrolls = await getEmployeePayrollHistory(event.employeeId);
      emit(EmployeePayrollHistoryLoaded(payrolls));
    } catch (e) {
      final exception = ErrorHandler.handle(e);
      ErrorHandler.logError(exception);
      emit(PayrollError(exception.message));
    }
  }

  Future<void> _onGeneratePayroll(GeneratePayroll event, Emitter<PayrollState> emit) async {
    emit(PayrollLoading());
    try {
      final payroll = await generatePayroll.call(event.payrollData);
      emit(PayrollGenerated(payroll));
    } catch (e) {
      final exception = ErrorHandler.handle(e);
      ErrorHandler.logError(exception);
      emit(PayrollError(exception.message));
    }
  }

  Future<void> _onApprovePayroll(ApprovePayroll event, Emitter<PayrollState> emit) async {
    emit(PayrollLoading());
    try {
      final payroll = await approvePayroll.call(event.payrollId);
      emit(PayrollApproved(payroll));
    } catch (e) {
      emit(PayrollError(e.toString()));
    }
  }

  Future<void> _onMarkPayrollAsPaid(MarkPayrollAsPaid event, Emitter<PayrollState> emit) async {
    emit(PayrollLoading());
    try {
      final payroll = await markPayrollAsPaid.call(event.payrollId, event.paymentData);
      emit(PayrollMarkedAsPaid(payroll));
    } catch (e) {
      emit(PayrollError(e.toString()));
    }
  }

  Future<void> _onLoadPayrollStats(LoadPayrollStats event, Emitter<PayrollState> emit) async {
    emit(PayrollLoading());
    try {
      final stats = await getPayrollStats();
      emit(PayrollStatsLoaded(stats));
    } catch (e) {
      emit(PayrollError(e.toString()));
    }
  }

  Future<void> _onBulkApprovePayrolls(BulkApprovePayrolls event, Emitter<PayrollState> emit) async {
    emit(PayrollLoading());
    try {
      await bulkApprovePayrolls.call(event.payrollIds);
      emit(PayrollsBulkApproved(event.payrollIds));
    } catch (e) {
      emit(PayrollError(e.toString()));
    }
  }

  Future<void> _onDeletePayroll(DeletePayroll event, Emitter<PayrollState> emit) async {
    emit(PayrollLoading());
    try {
      await deletePayroll.call(event.payrollId);
      emit(PayrollDeleted(event.payrollId));
    } catch (e) {
      emit(PayrollError(e.toString()));
    }
  }
} 
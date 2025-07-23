import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hready/features/payroll/domain/repositories/payroll_repository.dart';
import 'package:hready/features/payroll/presentation/view_model/payroll_event.dart';
import 'package:hready/features/payroll/presentation/view_model/payroll_state.dart';
import '../../data/models/payroll_model.dart';
import '../../data/repositories/payroll_repository.dart';


class PayrollBloc extends Bloc<PayrollEvent, PayrollState> {
  final PayrollRepository repository;
  PayrollBloc(this.repository) : super(PayrollInitial()) {
    on<LoadPayrolls>(_onLoadPayrolls);
    on<LoadPayrollStats>(_onLoadPayrollStats);
  }

  Future<void> _onLoadPayrolls(LoadPayrolls event, Emitter<PayrollState> emit) async {
    emit(PayrollLoading());
    try {
      final payrolls = await repository.getAllPayrolls(month: event.month, year: event.year, status: event.status) as List<PayrollModel>;
      emit(PayrollLoaded(payrolls));
    } catch (e) {
      emit(PayrollError(e.toString()));
    }
  }

  Future<void> _onLoadPayrollStats(LoadPayrollStats event, Emitter<PayrollState> emit) async {
    emit(PayrollStatsLoading());
    try {
      final stats = await repository.getPayrollStats(year: event.year);
      emit(PayrollStatsLoaded(stats));
    } catch (e) {
      emit(PayrollStatsError(e.toString()));
    }
  }
} 
import 'package:equatable/equatable.dart';
import '../../data/models/payroll_model.dart';

abstract class PayrollState extends Equatable {
  const PayrollState();
  @override
  List<Object?> get props => [];
}

class PayrollInitial extends PayrollState {}
class PayrollLoading extends PayrollState {}
class PayrollLoaded extends PayrollState {
  final List<PayrollModel> payrolls;
  const PayrollLoaded(this.payrolls);
  @override
  List<Object?> get props => [payrolls];
}
class PayrollError extends PayrollState {
  final String message;
  const PayrollError(this.message);
  @override
  List<Object?> get props => [message];
}

class PayrollStatsLoading extends PayrollState {}
class PayrollStatsLoaded extends PayrollState {
  final Map<String, dynamic> stats;
  const PayrollStatsLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}
class PayrollStatsError extends PayrollState {
  final String message;
  const PayrollStatsError(this.message);
  @override
  List<Object?> get props => [message];
} 
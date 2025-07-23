import 'package:equatable/equatable.dart';

abstract class PayrollEvent extends Equatable {
  const PayrollEvent();
  @override
  List<Object?> get props => [];
}

class LoadPayrolls extends PayrollEvent {
  final int? month;
  final int? year;
  final String? status;
  const LoadPayrolls({this.month, this.year, this.status});
  @override
  List<Object?> get props => [month, year, status];
}

class LoadPayrollStats extends PayrollEvent {
  final int? year;
  const LoadPayrollStats({this.year});
  @override
  List<Object?> get props => [year];
} 
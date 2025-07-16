import 'package:equatable/equatable.dart';

abstract class EmployeeDashboardEvent extends Equatable {
  const EmployeeDashboardEvent();

  @override
  List<Object> get props => [];
}

class EmployeeTabChanged extends EmployeeDashboardEvent {
  final int selectedIndex;

  const EmployeeTabChanged(this.selectedIndex);

  @override
  List<Object> get props => [selectedIndex];
}

class LoadEmployeeDashboard extends EmployeeDashboardEvent {}

class RefreshEmployeeDashboard extends EmployeeDashboardEvent {}

class EmployeeDashboardError extends EmployeeDashboardEvent {
  final String error;
  const EmployeeDashboardError(this.error);

  @override
  List<Object> get props => [error];
}

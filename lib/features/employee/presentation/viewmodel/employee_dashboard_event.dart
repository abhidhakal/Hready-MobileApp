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

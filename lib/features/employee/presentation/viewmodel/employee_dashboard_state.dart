import 'package:equatable/equatable.dart';

class EmployeeDashboardState extends Equatable {
  final int selectedIndex;

  const EmployeeDashboardState({required this.selectedIndex});

  EmployeeDashboardState copyWith({int? selectedIndex}) {
    return EmployeeDashboardState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => [selectedIndex];
}

import 'package:equatable/equatable.dart';

class AdminDashboardState extends Equatable {
  final int selectedIndex;

  const AdminDashboardState({required this.selectedIndex});

  AdminDashboardState copyWith({int? selectedIndex}) {
    return AdminDashboardState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => [selectedIndex];
}

import 'package:equatable/equatable.dart';

abstract class AdminDashboardEvent extends Equatable {
  const AdminDashboardEvent();

  @override
  List<Object> get props => [];
}

class AdminTabChanged extends AdminDashboardEvent {
  final int selectedIndex;

  const AdminTabChanged(this.selectedIndex);

  @override
  List<Object> get props => [selectedIndex];
}

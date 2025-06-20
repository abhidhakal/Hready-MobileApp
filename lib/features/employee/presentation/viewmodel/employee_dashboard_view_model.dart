import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/employee/presentation/viewmodel/employee_dashboard_event.dart';
import 'package:hready/features/employee/presentation/viewmodel/employee_dashboard_state.dart';

class EmployeeDashboardViewModel extends Bloc<EmployeeDashboardEvent, EmployeeDashboardState> {
  EmployeeDashboardViewModel() : super(const EmployeeDashboardState(selectedIndex: 0)) {
    on<EmployeeTabChanged>((event, emit) {
      emit(state.copyWith(selectedIndex: event.selectedIndex));
    });
  }
}

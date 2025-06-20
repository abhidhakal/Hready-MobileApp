import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/admin/presentation/viewmodel/admin_dashboard_event.dart';
import 'package:hready/features/admin/presentation/viewmodel/admin_dashboard_state.dart';

class AdminDashboardViewModel extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  AdminDashboardViewModel() : super(const AdminDashboardState(selectedIndex: 0)) {
    on<AdminTabChanged>((event, emit) {
      emit(state.copyWith(selectedIndex: event.selectedIndex));
    });
  }
}

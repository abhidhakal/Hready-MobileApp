import 'package:bloc_test/bloc_test.dart';

import 'package:hready/features/admin/presentation/viewmodel/admin_dashboard_view_model.dart';
import 'package:hready/features/admin/presentation/viewmodel/admin_dashboard_event.dart';
import 'package:hready/features/admin/presentation/viewmodel/admin_dashboard_state.dart';

void main() {
  blocTest<AdminDashboardViewModel, AdminDashboardState>(
    'emits state with selectedIndex updated when AdminTabChanged is added',
    build: () => AdminDashboardViewModel(),
    act: (bloc) => bloc.add(const AdminTabChanged(3)),
    expect: () => [
      const AdminDashboardState(selectedIndex: 3),
    ],
  );
}

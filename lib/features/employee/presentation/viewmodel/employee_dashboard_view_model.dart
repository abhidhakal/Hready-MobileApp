import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/employee/presentation/viewmodel/employee_dashboard_event.dart';
import 'package:hready/features/employee/presentation/viewmodel/employee_dashboard_state.dart';
import 'package:hready/features/employee/domain/use_cases/get_employee_profile_use_case.dart';
import 'package:hready/features/attendance/domain/use_cases/get_my_attendance_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/get_my_tasks_use_case.dart';
import 'package:hready/features/announcements/domain/use_cases/get_announcements_use_case.dart';
import 'package:hready/features/leaves/domain/use_cases/get_my_leaves_use_case.dart';
import 'package:hready/features/auth/domain/use_cases/get_cached_user_use_case.dart';
import 'package:hready/app/service_locator/service_locator.dart';

class EmployeeDashboardViewModel extends Bloc<EmployeeDashboardEvent, EmployeeDashboardState> {
  final GetEmployeeProfileUseCase getEmployeeProfileUseCase = getIt<GetEmployeeProfileUseCase>();
  final GetMyAttendanceUseCase getMyAttendanceUseCase = getIt<GetMyAttendanceUseCase>();
  final GetMyTasksUseCase getMyTasksUseCase = getIt<GetMyTasksUseCase>();
  final GetAnnouncementsUseCase getAnnouncementsUseCase = getIt<GetAnnouncementsUseCase>();
  final GetMyLeavesUseCase getMyLeavesUseCase = getIt<GetMyLeavesUseCase>();
  final GetCachedUserUseCase getCachedUserUseCase = getIt<GetCachedUserUseCase>();

  EmployeeDashboardViewModel() : super(const EmployeeDashboardState(selectedIndex: 0)) {
    on<EmployeeTabChanged>((event, emit) {
      emit(state.copyWith(selectedIndex: event.selectedIndex));
    });
    on<LoadEmployeeDashboard>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final user = await getEmployeeProfileUseCase();
        final attendance = await getMyAttendanceUseCase();
        String attendanceStatus = 'Not Done';
        if (attendance.checkInTime != null && attendance.checkOutTime == null) {
          attendanceStatus = 'Checked In';
        } else if (attendance.checkInTime != null && attendance.checkOutTime != null) {
          attendanceStatus = 'Checked Out';
        }
        final tasks = await getMyTasksUseCase();
        final announcements = await getAnnouncementsUseCase();
        final leaves = await getMyLeavesUseCase();
        final now = DateTime.now();
        final leavesThisMonth = leaves.where((l) =>
          l.startDate != null &&
          l.status != null &&
          l.status!.toLowerCase() == 'approved' &&
          l.startDate!.year == now.year &&
          l.startDate!.month == now.month
        ).length;
        final leaveDaysLeft = 4 - leavesThisMonth;
        emit(state.copyWith(
          user: user,
          attendanceStatus: attendanceStatus,
          tasks: tasks,
          announcements: announcements,
          leaveDaysLeft: leaveDaysLeft < 0 ? 0 : leaveDaysLeft,
          isLoading: false,
          error: null,
        ));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });
  }
}

// test/mocks/mock_auth_view_model.dart

import 'package:mocktail/mocktail.dart';
import 'package:hready/features/auth/presentation/viewmodel/auth_view_model.dart';
import 'package:hready/features/admin/presentation/viewmodel/admin_dashboard_view_model.dart';
import 'package:hready/features/employee/presentation/viewmodel/employee_profile_bloc.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_bloc.dart';
import 'package:hready/features/tasks/presentation/view_model/task_bloc.dart';
import 'package:hready/features/leaves/presentation/view_model/leave_bloc.dart';
import 'package:hready/features/announcements/presentation/view_model/announcement_view_model.dart';

class MockAuthViewModel extends Mock implements AuthViewModel {}
class MockAdminDashboardViewModel extends Mock implements AdminDashboardViewModel {}
class MockEmployeeProfileBloc extends Mock implements EmployeeProfileBloc {}
class MockAttendanceBloc extends Mock implements AttendanceBloc {}
class MockTaskBloc extends Mock implements TaskBloc {}
class MockLeaveBloc extends Mock implements LeaveBloc {}
class MockAnnouncementViewModel extends Mock implements AnnouncementViewModel {}
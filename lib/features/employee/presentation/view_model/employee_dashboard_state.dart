import 'package:equatable/equatable.dart';
import 'package:hready/features/employee/domain/entities/employee_entity.dart';
import 'package:hready/features/tasks/domain/entities/task_entity.dart';
import 'package:hready/features/announcements/domain/entities/announcement_entity.dart';
import 'package:hready/features/auth/domain/entities/user_entity.dart';

class EmployeeDashboardState extends Equatable {
  final int selectedIndex;
  final UserEntity? user;
  final String attendanceStatus;
  final int leaveDaysLeft;
  final List<TaskEntity> tasks;
  final List<AnnouncementEntity> announcements;
  final bool isLoading;
  final String? error;

  const EmployeeDashboardState({
    required this.selectedIndex,
    this.user,
    this.attendanceStatus = 'Not Done',
    this.leaveDaysLeft = 0,
    this.tasks = const [],
    this.announcements = const [],
    this.isLoading = false,
    this.error,
  });

  EmployeeDashboardState copyWith({
    int? selectedIndex,
    UserEntity? user,
    String? attendanceStatus,
    int? leaveDaysLeft,
    List<TaskEntity>? tasks,
    List<AnnouncementEntity>? announcements,
    bool? isLoading,
    String? error,
  }) {
    return EmployeeDashboardState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      user: user ?? this.user,
      attendanceStatus: attendanceStatus ?? this.attendanceStatus,
      leaveDaysLeft: leaveDaysLeft ?? this.leaveDaysLeft,
      tasks: tasks ?? this.tasks,
      announcements: announcements ?? this.announcements,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, user, attendanceStatus, leaveDaysLeft, tasks, announcements, isLoading, error];
}

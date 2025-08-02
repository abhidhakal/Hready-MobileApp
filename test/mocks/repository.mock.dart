import 'package:mocktail/mocktail.dart';
import 'package:hready/features/auth/domain/repositories/auth_repository.dart';
import 'package:hready/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:hready/features/tasks/domain/repositories/task_repository.dart';
import 'package:hready/features/leaves/domain/repositories/leave_repository.dart';
import 'package:hready/features/announcements/domain/repositories/announcement_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockAttendanceRepository extends Mock implements AttendanceRepository {}
class MockTaskRepository extends Mock implements TaskRepository {}
class MockLeaveRepository extends Mock implements LeaveRepository {}
class MockAnnouncementRepository extends Mock implements AnnouncementRepository {}

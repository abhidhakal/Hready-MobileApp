import '../entities/attendance_entity.dart';
import '../repositories/attendance_repository.dart';

class UpdateAttendanceUseCase {
  final AttendanceRepository repository;
  UpdateAttendanceUseCase(this.repository);

  Future<AttendanceEntity> call(String id, AttendanceEntity attendance) => repository.updateAttendance(id, attendance);
} 
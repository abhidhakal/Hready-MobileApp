import '../entities/attendance_entity.dart';
import '../repositories/attendance_repository.dart';

class CreateAttendanceUseCase {
  final AttendanceRepository repository;
  CreateAttendanceUseCase(this.repository);

  Future<AttendanceEntity> call(AttendanceEntity attendance) => repository.createAttendance(attendance);
} 
import '../entities/attendance_entity.dart';
import '../repositories/attendance_repository.dart';

class MarkAttendanceUseCase {
  final AttendanceRepository repository;
  MarkAttendanceUseCase(this.repository);

  Future<AttendanceEntity> call({required bool checkIn}) => repository.markAttendance(checkIn: checkIn);
} 
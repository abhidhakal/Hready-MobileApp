import '../entities/attendance_entity.dart';
import '../repositories/attendance_repository.dart';

class GetMyAttendanceUseCase {
  final AttendanceRepository repository;
  GetMyAttendanceUseCase(this.repository);

  Future<AttendanceEntity> call() => repository.getMyAttendance();
} 
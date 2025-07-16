import '../entities/attendance_entity.dart';
import '../repositories/attendance_repository.dart';

class GetAttendanceByIdUseCase {
  final AttendanceRepository repository;
  GetAttendanceByIdUseCase(this.repository);

  Future<AttendanceEntity> call(String id) => repository.getAttendanceById(id);
} 
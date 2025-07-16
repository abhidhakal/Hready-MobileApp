import '../entities/attendance_entity.dart';
import '../repositories/attendance_repository.dart';

class GetAllAttendanceUseCase {
  final AttendanceRepository repository;
  GetAllAttendanceUseCase(this.repository);

  Future<List<AttendanceEntity>> call() => repository.getAllAttendance();
} 
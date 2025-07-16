import '../repositories/attendance_repository.dart';

class DeleteAttendanceUseCase {
  final AttendanceRepository repository;
  DeleteAttendanceUseCase(this.repository);

  Future<void> call(String id) => repository.deleteAttendance(id);
} 
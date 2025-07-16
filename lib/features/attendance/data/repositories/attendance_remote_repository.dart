import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/remote_datasource/attendance_remote_data_source.dart';
import '../models/attendance_model.dart';

class AttendanceRemoteRepository implements AttendanceRepository {
  final AttendanceRemoteDataSource remoteDataSource;
  AttendanceRemoteRepository(this.remoteDataSource);

  @override
  Future<List<AttendanceEntity>> getAllAttendance() async {
    final models = await remoteDataSource.getAllAttendance();
    return models.map(_toEntity).toList();
  }

  @override
  Future<AttendanceEntity> getAttendanceById(String id) async {
    final model = await remoteDataSource.getAttendanceById(id);
    return _toEntity(model);
  }

  @override
  Future<AttendanceEntity> createAttendance(AttendanceEntity attendance) async {
    final model = AttendanceModel(
      id: attendance.id,
      user: attendance.user,
      checkInTime: attendance.checkInTime,
      checkOutTime: attendance.checkOutTime,
      date: attendance.date,
      status: attendance.status,
    );
    final created = await remoteDataSource.createAttendance(model);
    return _toEntity(created);
  }

  @override
  Future<AttendanceEntity> updateAttendance(String id, AttendanceEntity attendance) async {
    final model = AttendanceModel(
      id: attendance.id,
      user: attendance.user,
      checkInTime: attendance.checkInTime,
      checkOutTime: attendance.checkOutTime,
      date: attendance.date,
      status: attendance.status,
    );
    final updated = await remoteDataSource.updateAttendance(id, model);
    return _toEntity(updated);
  }

  @override
  Future<void> deleteAttendance(String id) async {
    await remoteDataSource.deleteAttendance(id);
  }

  @override
  Future<AttendanceEntity> getMyAttendance() async {
    final model = await remoteDataSource.getMyAttendance();
    return _toEntity(model);
  }

  @override
  Future<AttendanceEntity> markAttendance({required bool checkIn}) async {
    final model = await remoteDataSource.markAttendance(checkIn: checkIn);
    return _toEntity(model);
  }

  AttendanceEntity _toEntity(AttendanceModel m) => AttendanceEntity(
    id: m.id,
    user: m.user,
    checkInTime: m.checkInTime,
    checkOutTime: m.checkOutTime,
    date: m.date,
    status: m.status,
  );
} 
import '../entities/attendance_entity.dart';

abstract class AttendanceRepository {
  Future<List<AttendanceEntity>> getAllAttendance();
  Future<AttendanceEntity> getAttendanceById(String id);
  Future<AttendanceEntity> createAttendance(AttendanceEntity attendance);
  Future<AttendanceEntity> updateAttendance(String id, AttendanceEntity attendance);
  Future<void> deleteAttendance(String id);
  Future<AttendanceEntity> getMyAttendance();
  Future<AttendanceEntity> markAttendance({required bool checkIn});
} 
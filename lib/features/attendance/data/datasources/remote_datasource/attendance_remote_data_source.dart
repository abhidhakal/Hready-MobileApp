import '../../models/attendance_model.dart';
import 'package:dio/dio.dart';

class AttendanceRemoteDataSource {
  final Dio dio;
  AttendanceRemoteDataSource(this.dio);

  Future<List<AttendanceModel>> getAllAttendance() async {
    final response = await dio.get('/attendance/all');
    return (response.data as List).map((json) => AttendanceModel.fromJson(json)).toList();
  }

  Future<AttendanceModel> getAttendanceById(String id) async {
    final response = await dio.get('/attendance/$id');
    return AttendanceModel.fromJson(response.data);
  }

  Future<AttendanceModel> createAttendance(AttendanceModel attendance) async {
    final response = await dio.post('/attendance', data: attendance.toJson());
    return AttendanceModel.fromJson(response.data);
  }

  Future<AttendanceModel> updateAttendance(String id, AttendanceModel attendance) async {
    final response = await dio.put('/attendance/$id', data: attendance.toJson());
    return AttendanceModel.fromJson(response.data);
  }

  Future<void> deleteAttendance(String id) async {
    await dio.delete('/attendance/$id');
  }

  Future<AttendanceModel> getMyAttendance() async {
    final response = await dio.get('/attendance/me');
    return AttendanceModel.fromJson(response.data);
  }

  Future<AttendanceModel> markAttendance({required bool checkIn}) async {
    if (checkIn) {
      print('DIO REQUEST: POST /attendance/checkin');
      final response = await dio.post('/attendance/checkin', data: {}); // send empty JSON object
      return AttendanceModel.fromJson(response.data);
    } else {
      print('DIO REQUEST: PUT /attendance/checkout (before request)');
      try {
        final response = await dio.put(
          '/attendance/checkout',
          data: {'date': DateTime.now().toUtc().toIso8601String()},
        ).timeout(const Duration(seconds: 10));
        print('DIO REQUEST: PUT /attendance/checkout (after response)');
        return AttendanceModel.fromJson(response.data);
      } catch (e) {
        print('DIO CHECK-OUT TIMEOUT OR ERROR: $e');
        rethrow;
      }
    }
  }
} 
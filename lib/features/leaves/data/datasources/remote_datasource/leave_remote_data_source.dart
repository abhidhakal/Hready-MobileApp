import '../../models/leave_model.dart';
import 'package:dio/dio.dart';

class LeaveRemoteDataSource {
  final Dio dio;
  LeaveRemoteDataSource(this.dio);

  Future<List<LeaveModel>> getAllLeaves() async {
    final response = await dio.get('/leaves/all');
    return (response.data as List).map((json) => LeaveModel.fromJson(json)).toList();
  }

  Future<LeaveModel> getLeaveById(String id) async {
    final response = await dio.get('/leaves/$id');
    return LeaveModel.fromJson(response.data);
  }

  Future<LeaveModel> createLeave(LeaveModel leave) async {
    final response = await dio.post('/leaves', data: leave.toJson());
    return LeaveModel.fromJson(response.data['leave'] ?? response.data);
  }

  Future<LeaveModel> updateLeave(String id, LeaveModel leave) async {
    final response = await dio.put('/leaves/$id', data: leave.toJson());
    return LeaveModel.fromJson(response.data);
  }

  Future<void> deleteLeave(String id) async {
    await dio.delete('/leaves/$id');
  }

  Future<List<LeaveModel>> getMyLeaves() async {
    final options = Options();
    print('DIO TOKEN (getMyLeaves): ' + (dio.options.headers['Authorization']?.toString() ?? 'NO TOKEN'));
    final response = await dio.get('/leaves', options: options);
    print('DIO RESPONSE (getMyLeaves): ' + response.data.toString());
    return (response.data as List).map((json) => LeaveModel.fromJson(json)).toList();
  }

  Future<LeaveModel> updateLeaveStatus(String id, String status, {String? adminComment}) async {
    final response = await dio.put('/leaves/$id/status', data: {'status': status, 'adminComment': adminComment});
    return LeaveModel.fromJson(response.data['leave'] ?? response.data);
  }

  Future<LeaveModel> createAdminLeave(LeaveModel leave) async {
    final response = await dio.post('/leaves/admin', data: leave.toJson());
    return LeaveModel.fromJson(response.data['leave'] ?? response.data);
  }
} 
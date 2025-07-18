import '../../models/request_model.dart';
import 'dart:io';
import 'package:dio/dio.dart';

abstract class RequestRemoteDataSource {
  Future<List<RequestModel>> getAllRequests();
  Future<void> approveRequest(String requestId, {String? comment});
  Future<void> rejectRequest(String requestId, {String? comment});
  Future<List<RequestModel>> getMyRequests();
  Future<void> submitRequest({required String title, required String message, required String type, File? attachment});
}

class RequestRemoteDataSourceImpl implements RequestRemoteDataSource {
  final Dio dio;
  RequestRemoteDataSourceImpl(this.dio);

  @override
  Future<List<RequestModel>> getAllRequests() async {
    final response = await dio.get('/requests');
    final data = response.data as List;
    return data.map((json) => RequestModel.fromJson(json)).toList();
  }

  @override
  Future<void> approveRequest(String requestId, {String? comment}) async {
    await dio.patch('/requests/$requestId/status', data: {
      'status': 'approved',
      if (comment != null) 'adminComment': comment,
    });
  }

  @override
  Future<void> rejectRequest(String requestId, {String? comment}) async {
    await dio.patch('/requests/$requestId/status', data: {
      'status': 'rejected',
      if (comment != null) 'adminComment': comment,
    });
  }

  @override
  Future<List<RequestModel>> getMyRequests() async {
    final response = await dio.get('/requests/my');
    final data = response.data as List;
    return data.map((json) => RequestModel.fromJson(json)).toList();
  }

  @override
  Future<void> submitRequest({required String title, required String message, required String type, File? attachment}) async {
    final formData = FormData.fromMap({
      'title': title,
      'message': message,
      'type': type,
      if (attachment != null)
        'attachment': await MultipartFile.fromFile(attachment.path, filename: attachment.path.split('/').last),
    });
    await dio.post('/requests', data: formData);
  }
} 
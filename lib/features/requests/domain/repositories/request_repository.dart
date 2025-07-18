import '../entities/request_entity.dart';
import 'dart:io';

abstract class RequestRepository {
  Future<List<RequestEntity>> getAllRequests();
  Future<void> approveRequest(String requestId, {String? comment});
  Future<void> rejectRequest(String requestId, {String? comment});
  Future<List<RequestEntity>> getMyRequests();
  Future<void> submitRequest({required String title, required String message, required String type, File? attachment});
} 
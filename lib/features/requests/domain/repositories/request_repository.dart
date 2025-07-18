import '../entities/request_entity.dart';

abstract class RequestRepository {
  Future<List<RequestEntity>> getAllRequests();
  Future<void> approveRequest(String requestId);
  Future<void> rejectRequest(String requestId);
} 
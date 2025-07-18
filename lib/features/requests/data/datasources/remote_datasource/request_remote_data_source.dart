import '../../models/request_model.dart';

abstract class RequestRemoteDataSource {
  Future<List<RequestModel>> getAllRequests();
  Future<void> approveRequest(String requestId);
  Future<void> rejectRequest(String requestId);
}

class RequestRemoteDataSourceImpl implements RequestRemoteDataSource {
  @override
  Future<List<RequestModel>> getAllRequests() async {
    // TODO: Implement API call
    return [];
  }

  @override
  Future<void> approveRequest(String requestId) async {
    // TODO: Implement API call
  }

  @override
  Future<void> rejectRequest(String requestId) async {
    // TODO: Implement API call
  }
} 
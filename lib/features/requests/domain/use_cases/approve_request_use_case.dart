import '../repositories/request_repository.dart';

class ApproveRequestUseCase {
  final RequestRepository repository;
  ApproveRequestUseCase(this.repository);

  Future<void> call(String requestId, {String? comment}) async {
    await repository.approveRequest(requestId, comment: comment);
  }
} 
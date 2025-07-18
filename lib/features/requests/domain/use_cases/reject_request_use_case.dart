import '../repositories/request_repository.dart';

class RejectRequestUseCase {
  final RequestRepository repository;
  RejectRequestUseCase(this.repository);

  Future<void> call(String requestId, {String? comment}) async {
    await repository.rejectRequest(requestId, comment: comment);
  }
} 
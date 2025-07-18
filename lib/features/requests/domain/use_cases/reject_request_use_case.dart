import '../repositories/request_repository.dart';

class RejectRequestUseCase {
  final RequestRepository repository;
  RejectRequestUseCase(this.repository);

  Future<void> call(String requestId) async {
    await repository.rejectRequest(requestId);
  }
} 
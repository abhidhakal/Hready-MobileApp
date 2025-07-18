import '../entities/request_entity.dart';
import '../repositories/request_repository.dart';

class GetMyRequestsUseCase {
  final RequestRepository repository;
  GetMyRequestsUseCase(this.repository);

  Future<List<RequestEntity>> call() async {
    return await repository.getMyRequests();
  }
} 
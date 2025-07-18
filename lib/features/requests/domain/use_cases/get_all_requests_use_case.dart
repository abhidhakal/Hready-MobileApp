import '../entities/request_entity.dart';
import '../repositories/request_repository.dart';

class GetAllRequestsUseCase {
  final RequestRepository repository;
  GetAllRequestsUseCase(this.repository);

  Future<List<RequestEntity>> call() async {
    return await repository.getAllRequests();
  }
} 
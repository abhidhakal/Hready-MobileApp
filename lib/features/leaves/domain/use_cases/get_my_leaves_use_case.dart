import '../entities/leave_entity.dart';
import '../repositories/leave_repository.dart';

class GetMyLeavesUseCase {
  final LeaveRepository repository;
  GetMyLeavesUseCase(this.repository);

  Future<List<LeaveEntity>> call() async {
    return await repository.getMyLeaves();
  }
} 
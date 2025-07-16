import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class UpdateMyTaskStatusUseCase {
  final TaskRepository repository;
  UpdateMyTaskStatusUseCase(this.repository);

  Future<TaskEntity> call(String id, String status) => repository.updateMyTaskStatus(id, status);
} 
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository repository;
  UpdateTaskUseCase(this.repository);

  Future<TaskEntity> call(String id, TaskEntity task) => repository.updateTask(id, task);
} 
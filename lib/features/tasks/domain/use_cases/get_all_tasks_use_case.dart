import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class GetAllTasksUseCase {
  final TaskRepository repository;
  GetAllTasksUseCase(this.repository);

  Future<List<TaskEntity>> call() => repository.getAllTasks();
} 
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class GetMyTasksUseCase {
  final TaskRepository repository;
  GetMyTasksUseCase(this.repository);

  Future<List<TaskEntity>> call() => repository.getMyTasks();
} 
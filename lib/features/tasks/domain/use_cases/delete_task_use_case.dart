import 'package:hready/features/tasks/domain/repositories/task_repository.dart';

class DeleteTaskUseCase {
  final TaskRepository repository;
  DeleteTaskUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.deleteTask(id);
  }
} 
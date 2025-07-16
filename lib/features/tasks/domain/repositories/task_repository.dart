import '../entities/task_entity.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> getAllTasks();
  Future<TaskEntity> getTaskById(String id);
  Future<TaskEntity> createTask(TaskEntity task);
  Future<TaskEntity> updateTask(String id, TaskEntity task);
  Future<void> deleteTask(String id);
  Future<List<TaskEntity>> getMyTasks();
  Future<TaskEntity> updateMyTaskStatus(String id, String status);
} 
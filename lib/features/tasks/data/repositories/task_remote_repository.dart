import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/remote_datasource/task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRemoteRepository implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  TaskRemoteRepository(this.remoteDataSource);

  @override
  Future<List<TaskEntity>> getAllTasks() async {
    final models = await remoteDataSource.getAllTasks();
    return models.map(_toEntity).toList();
  }

  @override
  Future<TaskEntity> getTaskById(String id) async {
    final model = await remoteDataSource.getTaskById(id);
    return _toEntity(model);
  }

  @override
  Future<TaskEntity> createTask(TaskEntity task) async {
    final model = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      assignedTo: task.assignedTo,
      assignedDepartment: task.assignedDepartment,
      status: task.status,
      createdBy: task.createdBy,
      createdAt: task.createdAt,
    );
    final created = await remoteDataSource.createTask(model);
    return _toEntity(created);
  }

  @override
  Future<TaskEntity> updateTask(String id, TaskEntity task) async {
    final model = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      assignedTo: task.assignedTo,
      assignedDepartment: task.assignedDepartment,
      status: task.status,
      createdBy: task.createdBy,
      createdAt: task.createdAt,
    );
    final updated = await remoteDataSource.updateTask(id, model);
    return _toEntity(updated);
  }

  @override
  Future<void> deleteTask(String id) async {
    await remoteDataSource.deleteTask(id);
  }

  @override
  Future<List<TaskEntity>> getMyTasks() async {
    final models = await remoteDataSource.getMyTasks();
    return models.map(_toEntity).toList();
  }

  @override
  Future<TaskEntity> updateMyTaskStatus(String id, String status) async {
    final updated = await remoteDataSource.updateMyTaskStatus(id, status);
    return _toEntity(updated);
  }

  TaskEntity _toEntity(TaskModel m) => TaskEntity(
    id: m.id,
    title: m.title,
    description: m.description,
    dueDate: m.dueDate,
    assignedTo: m.assignedTo,
    assignedDepartment: m.assignedDepartment,
    status: m.status,
    createdBy: m.createdBy,
    createdAt: m.createdAt,
  );
} 
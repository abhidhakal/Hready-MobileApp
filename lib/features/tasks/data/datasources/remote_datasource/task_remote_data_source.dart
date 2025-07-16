import '../../models/task_model.dart';
import 'package:dio/dio.dart';

class TaskRemoteDataSource {
  final Dio dio;
  TaskRemoteDataSource(this.dio);

  Future<List<TaskModel>> getAllTasks() async {
    final response = await dio.get('/tasks');
    return (response.data as List).map((json) => TaskModel.fromJson(json)).toList();
  }

  Future<TaskModel> getTaskById(String id) async {
    final response = await dio.get('/tasks/$id');
    return TaskModel.fromJson(response.data);
  }

  Future<TaskModel> createTask(TaskModel task) async {
    final response = await dio.post('/tasks', data: task.toJson());
    return TaskModel.fromJson(response.data);
  }

  Future<TaskModel> updateTask(String id, TaskModel task) async {
    final response = await dio.put('/tasks/$id', data: task.toJson());
    return TaskModel.fromJson(response.data);
  }

  Future<void> deleteTask(String id) async {
    await dio.delete('/tasks/$id');
  }

  Future<List<TaskModel>> getMyTasks() async {
    final response = await dio.get('/tasks/my');
    return (response.data as List).map((json) => TaskModel.fromJson(json)).toList();
  }

  Future<TaskModel> updateMyTaskStatus(String id, String status) async {
    final response = await dio.put('/tasks/my/$id/status', data: {'status': status});
    return TaskModel.fromJson(response.data);
  }
} 
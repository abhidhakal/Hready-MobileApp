import 'package:flutter/material.dart';
import 'package:hready/features/tasks/domain/entities/task_entity.dart';
import 'package:hready/features/auth/domain/entities/user_entity.dart';
import 'package:hready/features/tasks/domain/use_cases/get_all_tasks_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/create_task_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/update_task_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/get_all_users_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/get_my_tasks_use_case.dart';

class TaskViewModel extends ChangeNotifier {
  final GetAllTasksUseCase getAllTasksUseCase;
  final CreateTaskUseCase createTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final GetAllUsersUseCase getAllUsersUseCase;
  final GetMyTasksUseCase? getMyTasksUseCase;

  TaskViewModel({
    required this.getAllTasksUseCase,
    required this.createTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
    required this.getAllUsersUseCase,
    this.getMyTasksUseCase,
  });

  List<TaskEntity> tasks = [];
  List<UserEntity> users = [];
  bool isLoading = false;
  String? error;

  Future<void> loadTasksAndUsers({bool onlyMyTasks = false}) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final loadedTasks = onlyMyTasks && getMyTasksUseCase != null
          ? await getMyTasksUseCase!()
          : await getAllTasksUseCase();
      final loadedUsers = await getAllUsersUseCase();
      tasks = loadedTasks;
      users = loadedUsers;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(TaskEntity task) async {
    isLoading = true;
    notifyListeners();
    try {
      await createTaskUseCase(task);
      await loadTasksAndUsers();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTask(String id, TaskEntity task) async {
    isLoading = true;
    notifyListeners();
    try {
      await updateTaskUseCase(id, task);
      await loadTasksAndUsers();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    isLoading = true;
    notifyListeners();
    try {
      await deleteTaskUseCase(id);
      await loadTasksAndUsers();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }
} 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/tasks/presentation/view_model/task_event.dart';
import 'package:hready/features/tasks/presentation/view_model/task_state.dart';
import 'package:hready/features/tasks/domain/use_cases/get_all_tasks_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/get_my_tasks_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/create_task_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/update_task_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/get_all_users_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/update_my_task_status_use_case.dart';
import 'package:hready/features/auth/domain/entities/user_entity.dart';
import 'package:hready/core/notifications/simple_notification_service.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetAllTasksUseCase getAllTasksUseCase;
  final GetMyTasksUseCase getMyTasksUseCase;
  final CreateTaskUseCase createTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final GetAllUsersUseCase getAllUsersUseCase;
  final UpdateMyTaskStatusUseCase updateMyTaskStatusUseCase;

  TaskBloc({
    required this.getAllTasksUseCase,
    required this.getMyTasksUseCase,
    required this.createTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
    required this.getAllUsersUseCase,
    required this.updateMyTaskStatusUseCase,
  }) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<UpdateMyTaskStatus>(_onUpdateMyTaskStatus);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = event.onlyMyTasks
          ? await getMyTasksUseCase()
          : await getAllTasksUseCase();
      final users = event.onlyMyTasks
          ? <UserEntity>[] // Don't fetch users for employees
          : await getAllUsersUseCase();
      emit(TaskLoaded(tasks: tasks, users: users));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await createTaskUseCase(event.task);
      await simpleNotificationService.showSuccessNotification('Task created successfully!');
      add(const LoadTasks());
    } catch (e) {
      await simpleNotificationService.showErrorNotification('Failed to create task: ${e.toString()}');
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await updateTaskUseCase(event.id, event.task);
      await simpleNotificationService.showSuccessNotification('Task updated successfully!');
      add(const LoadTasks());
    } catch (e) {
      await simpleNotificationService.showErrorNotification('Failed to update task: ${e.toString()}');
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await deleteTaskUseCase(event.id);
      await simpleNotificationService.showSuccessNotification('Task deleted successfully!');
      add(const LoadTasks());
    } catch (e) {
      await simpleNotificationService.showErrorNotification('Failed to delete task: ${e.toString()}');
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onUpdateMyTaskStatus(UpdateMyTaskStatus event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await updateMyTaskStatusUseCase(event.id, event.status);
      await simpleNotificationService.showSuccessNotification('Task status updated to ${event.status}!');
      add(const LoadTasks(onlyMyTasks: true));
    } catch (e) {
      await simpleNotificationService.showErrorNotification('Failed to update task status: ${e.toString()}');
      emit(TaskError(e.toString()));
    }
  }
} 
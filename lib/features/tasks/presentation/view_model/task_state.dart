import 'package:equatable/equatable.dart';
import 'package:hready/features/tasks/domain/entities/task_entity.dart';
import 'package:hready/features/auth/domain/entities/user_entity.dart';

abstract class TaskState extends Equatable {
  const TaskState();
  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskEntity> tasks;
  final List<UserEntity> users;
  const TaskLoaded({required this.tasks, required this.users});
  @override
  List<Object?> get props => [tasks, users];
}

class TaskError extends TaskState {
  final String error;
  const TaskError(this.error);
  @override
  List<Object?> get props => [error];
} 
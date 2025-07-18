import 'package:equatable/equatable.dart';
import 'package:hready/features/tasks/domain/entities/task_entity.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();
  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {
  final bool onlyMyTasks;
  const LoadTasks({this.onlyMyTasks = false});
  @override
  List<Object?> get props => [onlyMyTasks];
}

class AddTask extends TaskEvent {
  final TaskEntity task;
  const AddTask(this.task);
  @override
  List<Object?> get props => [task];
}

class UpdateTask extends TaskEvent {
  final String id;
  final TaskEntity task;
  const UpdateTask(this.id, this.task);
  @override
  List<Object?> get props => [id, task];
}

class DeleteTask extends TaskEvent {
  final String id;
  const DeleteTask(this.id);
  @override
  List<Object?> get props => [id];
} 
import 'package:equatable/equatable.dart';
import 'package:hready/features/auth/domain/entities/user_entity.dart';

class TaskEntity extends Equatable {
  final String? id;
  final String? title;
  final String? description;
  final DateTime? dueDate;
  final UserEntity? assignedTo;
  final String? assignedDepartment;
  final String? status;
  final String? createdBy;
  final DateTime? createdAt;

  const TaskEntity({
    this.id,
    this.title,
    this.description,
    this.dueDate,
    this.assignedTo,
    this.assignedDepartment,
    this.status,
    this.createdBy,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, description, dueDate, assignedTo, assignedDepartment, status, createdBy, createdAt];
} 
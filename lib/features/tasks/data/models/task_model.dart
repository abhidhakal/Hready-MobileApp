import 'package:equatable/equatable.dart';

class TaskModel extends Equatable {
  final String? id;
  final String? title;
  final String? description;
  final DateTime? dueDate;
  final String? assignedTo;
  final String? assignedDepartment;
  final String? status;
  final String? createdBy;
  final DateTime? createdAt;

  const TaskModel({
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

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['_id']?.toString(),
        title: json['title'],
        description: json['description'],
        dueDate: json['dueDate'] != null ? DateTime.tryParse(json['dueDate']) : null,
        assignedTo: json['assignedTo'] is Map ? json['assignedTo']['_id'] : json['assignedTo']?.toString(),
        assignedDepartment: json['assignedDepartment'],
        status: json['status'],
        createdBy: json['createdBy'] is Map ? json['createdBy']['_id'] : json['createdBy']?.toString(),
        createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'dueDate': dueDate?.toIso8601String(),
        'assignedTo': assignedTo,
        'assignedDepartment': assignedDepartment,
        'status': status,
      };

  @override
  List<Object?> get props => [id, title, description, dueDate, assignedTo, assignedDepartment, status, createdBy, createdAt];
} 
import 'package:equatable/equatable.dart';

class CreatedByEntity extends Equatable {
  final String? name;
  final String? email;
  const CreatedByEntity({this.name, this.email});

  @override
  List<Object?> get props => [name, email];
}

class RequestEntity extends Equatable {
  final String id;
  final String title;
  final String type;
  final String status;
  final String message;
  final CreatedByEntity? createdBy;
  final DateTime createdAt;
  final String? attachment;
  final String? adminComment;

  const RequestEntity({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.message,
    this.createdBy,
    required this.createdAt,
    this.attachment,
    this.adminComment,
  });

  @override
  List<Object?> get props => [id, title, type, status, message, createdBy, createdAt, attachment, adminComment];
} 
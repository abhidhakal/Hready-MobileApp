import 'package:equatable/equatable.dart';

class CreatedByModel extends Equatable {
  final String? name;
  final String? email;
  const CreatedByModel({this.name, this.email});

  factory CreatedByModel.fromJson(Map<String, dynamic> json) => CreatedByModel(
    name: json['name'] as String?,
    email: json['email'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
  };

  @override
  List<Object?> get props => [name, email];
}

class RequestModel extends Equatable {
  final String id;
  final String title;
  final String type;
  final String status;
  final String message;
  final CreatedByModel? createdBy;
  final DateTime createdAt;
  final String? attachment;
  final String? adminComment;

  const RequestModel({
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

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
    id: json['_id'] as String,
    title: json['title'] as String? ?? '',
    type: json['type'] as String? ?? '',
    status: json['status'] as String? ?? '',
    message: json['message'] as String? ?? '',
    createdBy: json['createdBy'] is Map<String, dynamic>
        ? CreatedByModel.fromJson(json['createdBy'])
        : (json['createdBy'] is String
            ? CreatedByModel(name: json['createdBy'], email: null)
            : null),
    createdAt: DateTime.parse(json['createdAt'] as String),
    attachment: json['attachment'] as String?,
    adminComment: json['adminComment'] as String?,
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'title': title,
    'type': type,
    'status': status,
    'message': message,
    'createdBy': createdBy?.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'attachment': attachment,
    'adminComment': adminComment,
  };

  @override
  List<Object?> get props => [id, title, type, status, message, createdBy, createdAt, attachment, adminComment];
} 
import 'package:equatable/equatable.dart';

class AnnouncementEntity extends Equatable {
  final String? id;
  final String? title;
  final String? message;
  final String? audience;
  final String? postedBy;
  final DateTime? createdAt;

  const AnnouncementEntity({
    this.id,
    this.title,
    this.message,
    this.audience,
    this.postedBy,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, message, audience, postedBy, createdAt];
} 
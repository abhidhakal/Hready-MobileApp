import 'package:equatable/equatable.dart';

class LeaveEntity extends Equatable {
  final String? id;
  final String? requestedBy;
  final String? leaveType;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? halfDay;
  final String? reason;
  final String? attachment;
  final String? status;
  final String? adminComment;
  final DateTime? createdAt;

  const LeaveEntity({
    this.id,
    this.requestedBy,
    this.leaveType,
    this.startDate,
    this.endDate,
    this.halfDay,
    this.reason,
    this.attachment,
    this.status,
    this.adminComment,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, requestedBy, leaveType, startDate, endDate, halfDay, reason, attachment, status, adminComment, createdAt];
} 
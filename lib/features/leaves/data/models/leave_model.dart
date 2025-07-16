import 'package:equatable/equatable.dart';

class LeaveModel extends Equatable {
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

  const LeaveModel({
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

  factory LeaveModel.fromJson(Map<String, dynamic> json) => LeaveModel(
        id: json['_id']?.toString(),
        requestedBy: json['requestedBy'] is Map ? json['requestedBy']['_id'] : json['requestedBy']?.toString(),
        leaveType: json['leaveType'],
        startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate']) : null,
        endDate: json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
        halfDay: json['halfDay'] is bool ? json['halfDay'] : json['halfDay'] == 'true',
        reason: json['reason'],
        attachment: json['attachment'],
        status: json['status'],
        adminComment: json['adminComment'],
        createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      );

  Map<String, dynamic> toJson() => {
        'requestedBy': requestedBy,
        'leaveType': leaveType,
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'halfDay': halfDay,
        'reason': reason,
        'attachment': attachment,
        'status': status,
        'adminComment': adminComment,
      };

  @override
  List<Object?> get props => [id, requestedBy, leaveType, startDate, endDate, halfDay, reason, attachment, status, adminComment, createdAt];
} 
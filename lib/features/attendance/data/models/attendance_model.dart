import 'package:equatable/equatable.dart';

class AttendanceModel extends Equatable {
  final String? id;
  final String? user;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final DateTime? date;
  final String? status;

  const AttendanceModel({
    this.id,
    this.user,
    this.checkInTime,
    this.checkOutTime,
    this.date,
    this.status,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) => AttendanceModel(
        id: json['_id']?.toString(),
        user: json['user'] is Map ? json['user']['_id'] : json['user']?.toString(),
        checkInTime: json['check_in_time'] != null ? DateTime.tryParse(json['check_in_time']) : null,
        checkOutTime: json['check_out_time'] != null ? DateTime.tryParse(json['check_out_time']) : null,
        date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'user': user,
        'check_in_time': checkInTime?.toIso8601String(),
        'check_out_time': checkOutTime?.toIso8601String(),
        'date': date?.toIso8601String(),
        'status': status,
      };

  @override
  List<Object?> get props => [id, user, checkInTime, checkOutTime, date, status];
} 
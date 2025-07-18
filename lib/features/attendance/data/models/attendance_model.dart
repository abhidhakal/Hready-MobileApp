import 'package:equatable/equatable.dart';

class AttendanceModel extends Equatable {
  final String? id;
  final dynamic user;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final DateTime? date;
  final String? status;
  final double? totalHours;

  const AttendanceModel({
    this.id,
    this.user,
    this.checkInTime,
    this.checkOutTime,
    this.date,
    this.status,
    this.totalHours,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    final parsed = AttendanceModel(
      id: json['_id']?.toString(),
      user: json['user'], // store the whole user object (Map or String)
      checkInTime: json['check_in_time'] != null ? DateTime.tryParse(json['check_in_time']) : null,
      checkOutTime: json['check_out_time'] != null ? DateTime.tryParse(json['check_out_time']) : null,
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      status: json['status'],
      totalHours: json['total_hours'] != null ? double.tryParse(json['total_hours'].toString()) : null,
    );
    print('Attendance JSON: $json');
    print('Parsed totalHours: ${parsed.totalHours}');
    return parsed;
  }

  Map<String, dynamic> toJson() => {
        'user': user,
        'check_in_time': checkInTime?.toIso8601String(),
        'check_out_time': checkOutTime?.toIso8601String(),
        'date': date?.toIso8601String(),
        'status': status,
        'total_hours': totalHours,
      };

  @override
  List<Object?> get props => [id, user, checkInTime, checkOutTime, date, status, totalHours];
} 
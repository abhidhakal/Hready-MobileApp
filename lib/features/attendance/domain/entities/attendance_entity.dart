import 'package:equatable/equatable.dart';

class AttendanceEntity extends Equatable {
  final String? id;
  final dynamic user;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final DateTime? date;
  final String? status;
  final double? totalHours;

  const AttendanceEntity({
    this.id,
    this.user,
    this.checkInTime,
    this.checkOutTime,
    this.date,
    this.status,
    this.totalHours,
  });

  @override
  List<Object?> get props => [id, user, checkInTime, checkOutTime, date, status, totalHours];
} 
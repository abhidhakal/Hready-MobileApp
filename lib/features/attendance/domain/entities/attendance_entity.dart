import 'package:equatable/equatable.dart';

class AttendanceEntity extends Equatable {
  final String? id;
  final String? user;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final DateTime? date;
  final String? status;

  const AttendanceEntity({
    this.id,
    this.user,
    this.checkInTime,
    this.checkOutTime,
    this.date,
    this.status,
  });

  @override
  List<Object?> get props => [id, user, checkInTime, checkOutTime, date, status];
} 
import 'package:equatable/equatable.dart';
import 'package:hready/features/attendance/domain/entities/attendance_entity.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();
  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}
class AttendanceLoading extends AttendanceState {}
class AttendanceLoaded extends AttendanceState {
  final AttendanceEntity attendance;
  final String todayStatus;
  const AttendanceLoaded({required this.attendance, required this.todayStatus});
  @override
  List<Object?> get props => [attendance, todayStatus];
}
class AttendanceError extends AttendanceState {
  final String error;
  const AttendanceError(this.error);
  @override
  List<Object?> get props => [error];
}
class AdminAttendanceLoaded extends AttendanceState {
  final List<AttendanceEntity> allRecords;
  final AttendanceEntity? myRecord;
  final String todayStatus;
  const AdminAttendanceLoaded({required this.allRecords, required this.myRecord, required this.todayStatus});
  @override
  List<Object?> get props => [allRecords, myRecord, todayStatus];
} 
import 'package:equatable/equatable.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();
  @override
  List<Object?> get props => [];
}

class LoadTodayAttendance extends AttendanceEvent {}
class CheckIn extends AttendanceEvent {}
class CheckOut extends AttendanceEvent {}
class LoadAllAttendance extends AttendanceEvent {}
class LoadMyAttendance extends AttendanceEvent {} 
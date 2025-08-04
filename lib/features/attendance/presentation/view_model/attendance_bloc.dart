import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_event.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_state.dart';
import 'package:hready/features/attendance/domain/use_cases/get_my_attendance_use_case.dart';
import 'package:hready/features/attendance/domain/use_cases/mark_attendance_use_case.dart';
import 'package:hready/features/attendance/domain/entities/attendance_entity.dart';
import 'package:dio/dio.dart';
import 'package:hready/features/attendance/domain/use_cases/get_all_attendance_use_case.dart';
import 'package:hready/core/notifications/simple_notification_service.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final GetMyAttendanceUseCase getMyAttendanceUseCase;
  final MarkAttendanceUseCase markAttendanceUseCase;
  final GetAllAttendanceUseCase? getAllAttendanceUseCase;

  AttendanceBloc({
    required this.getMyAttendanceUseCase,
    required this.markAttendanceUseCase,
    this.getAllAttendanceUseCase,
  }) : super(AttendanceInitial()) {
    on<LoadTodayAttendance>(_onLoadTodayAttendance);
    on<CheckIn>(_onCheckIn);
    on<CheckOut>(_onCheckOut);
    on<LoadAllAttendance>(_onLoadAllAttendance);
    on<LoadMyAttendance>(_onLoadMyAttendance);
  }

  Future<void> _onLoadTodayAttendance(LoadTodayAttendance event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    try {
      final attendance = await getMyAttendanceUseCase();
      final todayStatus = _getTodayStatus(attendance);
      emit(AttendanceLoaded(attendance: attendance, todayStatus: todayStatus));
    } catch (e) {
      if (e is DioError && e.response?.statusCode == 404) {
        final msg = e.response?.data['message'] ?? '';
        if (msg.contains('No attendance found for today')) {
          emit(AttendanceLoaded(
            attendance: _emptyAttendanceEntity(),
            todayStatus: 'Not Checked In',
          ));
          return;
        }
      }
      emit(AttendanceError(e.toString()));
    }
  }

  Future<void> _onCheckIn(CheckIn event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    try {
      await markAttendanceUseCase(checkIn: true);
      // Show success notification
      await simpleNotificationService.showAttendanceNotification('Successfully checked in! Welcome to work.');
      // Reload data based on current state
      if (state is AdminAttendanceLoaded) {
        add(LoadAllAttendance());
      } else {
        add(LoadTodayAttendance());
      }
    } catch (e) {
      if (e is DioError) {
        print('DIO CHECK-IN ERROR: status=${e.response?.statusCode}, data=${e.response?.data}');
        if (e.response?.statusCode == 400 || e.response?.statusCode == 500) {
          final errorMessage = e.response?.data['message'] ?? 'Check-in failed.';
          await simpleNotificationService.showErrorNotification(errorMessage);
          emit(AttendanceError(errorMessage));
          return;
        }
      }
      await simpleNotificationService.showErrorNotification('Check-in failed. Please try again.');
      emit(AttendanceError(e.toString()));
    }
  }

  Future<void> _onCheckOut(CheckOut event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    try {
      await markAttendanceUseCase(checkIn: false);
      // Show success notification
      await simpleNotificationService.showAttendanceNotification('Successfully checked out! Have a great day.');
      // Reload data based on current state
      if (state is AdminAttendanceLoaded) {
        add(LoadAllAttendance());
      } else {
        add(LoadTodayAttendance());
      }
    } catch (e) {
      if (e is DioError) {
        print('DIO CHECK-OUT ERROR: status=${e.response?.statusCode}, data=${e.response?.data}');
        if (e.response?.statusCode == 400 || e.response?.statusCode == 500) {
          final errorMessage = e.response?.data['message'] ?? 'Check-out failed.';
          await simpleNotificationService.showErrorNotification(errorMessage);
          emit(AttendanceError(errorMessage));
          return;
        }
      }
      await simpleNotificationService.showErrorNotification('Check-out failed. Please try again.');
      emit(AttendanceError(e.toString()));
    }
  }

  Future<void> _onLoadAllAttendance(LoadAllAttendance event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    try {
      final allRecords = await getAllAttendanceUseCase!();
      AttendanceEntity? myRecord;
      String todayStatus = 'Not Checked In';
      try {
        myRecord = await getMyAttendanceUseCase();
        todayStatus = _getTodayStatus(myRecord);
      } catch (e) {
        myRecord = null;
      }
      emit(AdminAttendanceLoaded(allRecords: allRecords, myRecord: myRecord, todayStatus: todayStatus));
    } catch (e) {
      emit(AttendanceError(e.toString()));
    }
  }

  Future<void> _onLoadMyAttendance(LoadMyAttendance event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    try {
      final myRecord = await getMyAttendanceUseCase();
      final todayStatus = _getTodayStatus(myRecord);
      emit(AdminAttendanceLoaded(allRecords: const [], myRecord: myRecord, todayStatus: todayStatus));
    } catch (e) {
      emit(AttendanceError(e.toString()));
    }
  }

  String _getTodayStatus(attendance) {
    if (attendance.checkInTime != null && attendance.checkOutTime == null) {
      return 'Checked In';
    } else if (attendance.checkInTime != null && attendance.checkOutTime != null) {
      return 'Checked Out';
    } else {
      return 'Not Checked In';
    }
  }

  AttendanceEntity _emptyAttendanceEntity() => AttendanceEntity(
    id: null,
    user: null,
    checkInTime: null,
    checkOutTime: null,
    date: DateTime.now(),
    status: null,
    totalHours: null,
  );
} 
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_bloc.dart';
import 'package:hready/features/attendance/presentation/view_model/attendance_state.dart';
import 'package:hready/features/attendance/domain/use_cases/get_my_attendance_use_case.dart';
import 'package:hready/features/attendance/domain/use_cases/mark_attendance_use_case.dart';
import 'package:hready/features/attendance/domain/use_cases/get_all_attendance_use_case.dart';

class MockGetMyAttendanceUseCase extends Mock implements GetMyAttendanceUseCase {}
class MockMarkAttendanceUseCase extends Mock implements MarkAttendanceUseCase {}
class MockGetAllAttendanceUseCase extends Mock implements GetAllAttendanceUseCase {}

void main() {
  late AttendanceBloc attendanceBloc;
  late MockGetMyAttendanceUseCase mockGetMyAttendanceUseCase;
  late MockMarkAttendanceUseCase mockMarkAttendanceUseCase;
  late MockGetAllAttendanceUseCase mockGetAllAttendanceUseCase;

  setUp(() {
    mockGetMyAttendanceUseCase = MockGetMyAttendanceUseCase();
    mockMarkAttendanceUseCase = MockMarkAttendanceUseCase();
    mockGetAllAttendanceUseCase = MockGetAllAttendanceUseCase();

    attendanceBloc = AttendanceBloc(
      getMyAttendanceUseCase: mockGetMyAttendanceUseCase,
      markAttendanceUseCase: mockMarkAttendanceUseCase,
      getAllAttendanceUseCase: mockGetAllAttendanceUseCase,
    );
  });

  tearDown(() {
    attendanceBloc.close();
  });

  group('AttendanceBloc', () {
    test('initial state is AttendanceInitial', () {
      expect(attendanceBloc.state, isA<AttendanceInitial>());
    });

    test('bloc can be created', () {
      expect(attendanceBloc, isA<AttendanceBloc>());
    });

    test('bloc has correct use cases', () {
      expect(attendanceBloc.getMyAttendanceUseCase, equals(mockGetMyAttendanceUseCase));
      expect(attendanceBloc.markAttendanceUseCase, equals(mockMarkAttendanceUseCase));
      expect(attendanceBloc.getAllAttendanceUseCase, equals(mockGetAllAttendanceUseCase));
    });

    test('bloc can be closed', () {
      expect(() => attendanceBloc.close(), returnsNormally);
    });
  });
} 
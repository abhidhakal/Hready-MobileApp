import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hready/features/attendance/domain/use_cases/mark_attendance_use_case.dart';
import 'package:hready/features/attendance/domain/entities/attendance_entity.dart';

import '../../../../mocks/repository.mock.dart';

void main() {
  late MarkAttendanceUseCase markAttendanceUseCase;
  late MockAttendanceRepository mockAttendanceRepository;

  setUp(() {
    mockAttendanceRepository = MockAttendanceRepository();
    markAttendanceUseCase = MarkAttendanceUseCase(mockAttendanceRepository);
  });

  final tAttendance = AttendanceEntity(
    id: '1',
    checkInTime: DateTime.now(),
    date: DateTime.now(),
    status: 'present',
    totalHours: 8.0,
  );

  test('returns AttendanceEntity when check-in succeeds', () async {
    // Arrange
    when(() => mockAttendanceRepository.markAttendance(checkIn: true))
        .thenAnswer((_) async => tAttendance);

    // Act
    final result = await markAttendanceUseCase(checkIn: true);

    // Assert
    expect(result, tAttendance);
    verify(() => mockAttendanceRepository.markAttendance(checkIn: true)).called(1);
  });

  test('returns AttendanceEntity when check-out succeeds', () async {
    // Arrange
    when(() => mockAttendanceRepository.markAttendance(checkIn: false))
        .thenAnswer((_) async => tAttendance);

    // Act
    final result = await markAttendanceUseCase(checkIn: false);

    // Assert
    expect(result, tAttendance);
    verify(() => mockAttendanceRepository.markAttendance(checkIn: false)).called(1);
  });

  test('throws Exception when marking attendance fails', () async {
    // Arrange
    when(() => mockAttendanceRepository.markAttendance(checkIn: true))
        .thenThrow(Exception('Failed to mark attendance'));

    // Act & Assert
    expect(
      () => markAttendanceUseCase(checkIn: true),
      throwsA(isA<Exception>()),
    );
    verify(() => mockAttendanceRepository.markAttendance(checkIn: true)).called(1);
  });
} 
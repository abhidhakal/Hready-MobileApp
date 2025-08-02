import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hready/features/attendance/domain/use_cases/get_my_attendance_use_case.dart';
import 'package:hready/features/attendance/domain/entities/attendance_entity.dart';

import '../../../../mocks/repository.mock.dart';

void main() {
  late GetMyAttendanceUseCase getMyAttendanceUseCase;
  late MockAttendanceRepository mockAttendanceRepository;

  setUp(() {
    mockAttendanceRepository = MockAttendanceRepository();
    getMyAttendanceUseCase = GetMyAttendanceUseCase(mockAttendanceRepository);
  });

  final tAttendance = AttendanceEntity(
    id: '1',
    checkInTime: DateTime.now(),
    checkOutTime: DateTime.now().add(const Duration(hours: 8)),
    date: DateTime.now(),
    status: 'present',
    totalHours: 8.0,
  );

  test('returns AttendanceEntity when getting my attendance succeeds', () async {
    // Arrange
    when(() => mockAttendanceRepository.getMyAttendance())
        .thenAnswer((_) async => tAttendance);

    // Act
    final result = await getMyAttendanceUseCase();

    // Assert
    expect(result, tAttendance);
    verify(() => mockAttendanceRepository.getMyAttendance()).called(1);
  });

  test('throws Exception when getting my attendance fails', () async {
    // Arrange
    when(() => mockAttendanceRepository.getMyAttendance())
        .thenThrow(Exception('Failed to get attendance'));

    // Act & Assert
    expect(
      () => getMyAttendanceUseCase(),
      throwsA(isA<Exception>()),
    );
    verify(() => mockAttendanceRepository.getMyAttendance()).called(1);
  });
} 
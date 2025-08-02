import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hready/features/leaves/domain/use_cases/get_my_leaves_use_case.dart';
import 'package:hready/features/leaves/domain/entities/leave_entity.dart';

import '../../../../mocks/repository.mock.dart';

void main() {
  late GetMyLeavesUseCase getMyLeavesUseCase;
  late MockLeaveRepository mockLeaveRepository;

  setUp(() {
    mockLeaveRepository = MockLeaveRepository();
    getMyLeavesUseCase = GetMyLeavesUseCase(mockLeaveRepository);
  });

  final tLeaves = [
    LeaveEntity(
      id: '1',
      startDate: DateTime.now().add(const Duration(days: 7)),
      endDate: DateTime.now().add(const Duration(days: 10)),
      reason: 'Vacation',
      status: 'pending',
      leaveType: 'annual',
    ),
    LeaveEntity(
      id: '2',
      startDate: DateTime.now().add(const Duration(days: 14)),
      endDate: DateTime.now().add(const Duration(days: 15)),
      reason: 'Sick leave',
      status: 'approved',
      leaveType: 'sick',
    ),
  ];

  test('returns List<LeaveEntity> when getting my leaves succeeds', () async {
    // Arrange
    when(() => mockLeaveRepository.getMyLeaves())
        .thenAnswer((_) async => tLeaves);

    // Act
    final result = await getMyLeavesUseCase();

    // Assert
    expect(result, tLeaves);
    expect(result.length, 2);
    verify(() => mockLeaveRepository.getMyLeaves()).called(1);
  });

  test('returns empty list when no leaves found', () async {
    // Arrange
    when(() => mockLeaveRepository.getMyLeaves())
        .thenAnswer((_) async => <LeaveEntity>[]);

    // Act
    final result = await getMyLeavesUseCase();

    // Assert
    expect(result, isEmpty);
    verify(() => mockLeaveRepository.getMyLeaves()).called(1);
  });

  test('throws Exception when getting my leaves fails', () async {
    // Arrange
    when(() => mockLeaveRepository.getMyLeaves())
        .thenThrow(Exception('Failed to get leaves'));

    // Act & Assert
    expect(
      () => getMyLeavesUseCase(),
      throwsA(isA<Exception>()),
    );
    verify(() => mockLeaveRepository.getMyLeaves()).called(1);
  });
} 
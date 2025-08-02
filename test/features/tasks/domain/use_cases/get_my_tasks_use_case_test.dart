import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hready/features/tasks/domain/use_cases/get_my_tasks_use_case.dart';
import 'package:hready/features/tasks/domain/entities/task_entity.dart';
import 'package:hready/features/auth/domain/entities/user_entity.dart';

import '../../../../helpers/token.mock.dart';
import '../../../../mocks/repository.mock.dart';

void main() {
  late GetMyTasksUseCase getMyTasksUseCase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    getMyTasksUseCase = GetMyTasksUseCase(mockTaskRepository);
  });

  final tUser = UserEntity(
    userId: '1',
    name: 'Test User',
    email: 'test@example.com',
    role: 'employee',
    token: dummyToken,
  );

  final tTasks = [
    TaskEntity(
      id: '1',
      title: 'Task 1',
      description: 'Description 1',
      dueDate: DateTime.now().add(const Duration(days: 7)),
      assignedTo: tUser,
      assignedDepartment: 'IT',
      status: 'pending',
      createdBy: 'admin',
      createdAt: DateTime.now(),
    ),
    TaskEntity(
      id: '2',
      title: 'Task 2',
      description: 'Description 2',
      dueDate: DateTime.now().add(const Duration(days: 14)),
      assignedTo: tUser,
      assignedDepartment: 'IT',
      status: 'in_progress',
      createdBy: 'admin',
      createdAt: DateTime.now(),
    ),
  ];

  test('returns List<TaskEntity> when getting my tasks succeeds', () async {
    // Arrange
    when(() => mockTaskRepository.getMyTasks())
        .thenAnswer((_) async => tTasks);

    // Act
    final result = await getMyTasksUseCase();

    // Assert
    expect(result, tTasks);
    expect(result.length, 2);
    verify(() => mockTaskRepository.getMyTasks()).called(1);
  });

  test('returns empty list when no tasks found', () async {
    // Arrange
    when(() => mockTaskRepository.getMyTasks())
        .thenAnswer((_) async => <TaskEntity>[]);

    // Act
    final result = await getMyTasksUseCase();

    // Assert
    expect(result, isEmpty);
    verify(() => mockTaskRepository.getMyTasks()).called(1);
  });

  test('throws Exception when getting my tasks fails', () async {
    // Arrange
    when(() => mockTaskRepository.getMyTasks())
        .thenThrow(Exception('Failed to get tasks'));

    // Act & Assert
    expect(
      () => getMyTasksUseCase(),
      throwsA(isA<Exception>()),
    );
    verify(() => mockTaskRepository.getMyTasks()).called(1);
  });
} 
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hready/features/tasks/domain/use_cases/create_task_use_case.dart';
import 'package:hready/features/tasks/domain/entities/task_entity.dart';
import 'package:hready/features/auth/domain/entities/user_entity.dart';

import '../../../../helpers/token.mock.dart';
import '../../../../mocks/repository.mock.dart';

void main() {
  late CreateTaskUseCase createTaskUseCase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    createTaskUseCase = CreateTaskUseCase(mockTaskRepository);
  });

  final tUser = UserEntity(
    userId: '1',
    name: 'Test User',
    email: 'test@example.com',
    role: 'employee',
    token: dummyToken,
  );

  final tTask = TaskEntity(
    id: '1',
    title: 'Test Task',
    description: 'Test Description',
    dueDate: DateTime.now().add(const Duration(days: 7)),
    assignedTo: tUser,
    assignedDepartment: 'IT',
    status: 'pending',
    createdBy: 'admin',
    createdAt: DateTime.now(),
  );

  test('returns TaskEntity when creating task succeeds', () async {
    // Arrange
    when(() => mockTaskRepository.createTask(tTask))
        .thenAnswer((_) async => tTask);

    // Act
    final result = await createTaskUseCase(tTask);

    // Assert
    expect(result, tTask);
    verify(() => mockTaskRepository.createTask(tTask)).called(1);
  });

  test('throws Exception when creating task fails', () async {
    // Arrange
    when(() => mockTaskRepository.createTask(tTask))
        .thenThrow(Exception('Failed to create task'));

    // Act & Assert
    expect(
      () => createTaskUseCase(tTask),
      throwsA(isA<Exception>()),
    );
    verify(() => mockTaskRepository.createTask(tTask)).called(1);
  });
} 
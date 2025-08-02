import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hready/features/tasks/presentation/view_model/task_view_model.dart';
import 'package:hready/features/tasks/domain/use_cases/get_all_tasks_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/create_task_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/update_task_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/get_all_users_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/get_my_tasks_use_case.dart';

class MockGetAllTasksUseCase extends Mock implements GetAllTasksUseCase {}
class MockCreateTaskUseCase extends Mock implements CreateTaskUseCase {}
class MockUpdateTaskUseCase extends Mock implements UpdateTaskUseCase {}
class MockDeleteTaskUseCase extends Mock implements DeleteTaskUseCase {}
class MockGetAllUsersUseCase extends Mock implements GetAllUsersUseCase {}
class MockGetMyTasksUseCase extends Mock implements GetMyTasksUseCase {}

void main() {
  late TaskViewModel taskViewModel;
  late MockGetAllTasksUseCase mockGetAllTasksUseCase;
  late MockCreateTaskUseCase mockCreateTaskUseCase;
  late MockUpdateTaskUseCase mockUpdateTaskUseCase;
  late MockDeleteTaskUseCase mockDeleteTaskUseCase;
  late MockGetAllUsersUseCase mockGetAllUsersUseCase;
  late MockGetMyTasksUseCase mockGetMyTasksUseCase;

  setUp(() {
    mockGetAllTasksUseCase = MockGetAllTasksUseCase();
    mockCreateTaskUseCase = MockCreateTaskUseCase();
    mockUpdateTaskUseCase = MockUpdateTaskUseCase();
    mockDeleteTaskUseCase = MockDeleteTaskUseCase();
    mockGetAllUsersUseCase = MockGetAllUsersUseCase();
    mockGetMyTasksUseCase = MockGetMyTasksUseCase();

    taskViewModel = TaskViewModel(
      getAllTasksUseCase: mockGetAllTasksUseCase,
      createTaskUseCase: mockCreateTaskUseCase,
      updateTaskUseCase: mockUpdateTaskUseCase,
      deleteTaskUseCase: mockDeleteTaskUseCase,
      getAllUsersUseCase: mockGetAllUsersUseCase,
      getMyTasksUseCase: mockGetMyTasksUseCase,
    );
  });

  group('TaskViewModel', () {
    test('initial state has empty tasks list', () {
      expect(taskViewModel.tasks, isEmpty);
    });

    test('initial state has empty users list', () {
      expect(taskViewModel.users, isEmpty);
    });

    test('initial state has isLoading false', () {
      expect(taskViewModel.isLoading, false);
    });

    test('initial state has error null', () {
      expect(taskViewModel.error, null);
    });
  });
} 
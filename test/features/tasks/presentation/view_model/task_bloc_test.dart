import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:hready/features/tasks/presentation/view_model/task_bloc.dart';
import 'package:hready/features/tasks/presentation/view_model/task_state.dart';
import 'package:hready/features/tasks/domain/use_cases/get_all_tasks_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/get_my_tasks_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/create_task_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/update_task_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/get_all_users_use_case.dart';
import 'package:hready/features/tasks/domain/use_cases/update_my_task_status_use_case.dart';

class MockGetAllTasksUseCase extends Mock implements GetAllTasksUseCase {}
class MockGetMyTasksUseCase extends Mock implements GetMyTasksUseCase {}
class MockCreateTaskUseCase extends Mock implements CreateTaskUseCase {}
class MockUpdateTaskUseCase extends Mock implements UpdateTaskUseCase {}
class MockDeleteTaskUseCase extends Mock implements DeleteTaskUseCase {}
class MockGetAllUsersUseCase extends Mock implements GetAllUsersUseCase {}
class MockUpdateMyTaskStatusUseCase extends Mock implements UpdateMyTaskStatusUseCase {}

void main() {
  late TaskBloc taskBloc;
  late MockGetAllTasksUseCase mockGetAllTasksUseCase;
  late MockGetMyTasksUseCase mockGetMyTasksUseCase;
  late MockCreateTaskUseCase mockCreateTaskUseCase;
  late MockUpdateTaskUseCase mockUpdateTaskUseCase;
  late MockDeleteTaskUseCase mockDeleteTaskUseCase;
  late MockGetAllUsersUseCase mockGetAllUsersUseCase;
  late MockUpdateMyTaskStatusUseCase mockUpdateMyTaskStatusUseCase;

  setUp(() {
    mockGetAllTasksUseCase = MockGetAllTasksUseCase();
    mockGetMyTasksUseCase = MockGetMyTasksUseCase();
    mockCreateTaskUseCase = MockCreateTaskUseCase();
    mockUpdateTaskUseCase = MockUpdateTaskUseCase();
    mockDeleteTaskUseCase = MockDeleteTaskUseCase();
    mockGetAllUsersUseCase = MockGetAllUsersUseCase();
    mockUpdateMyTaskStatusUseCase = MockUpdateMyTaskStatusUseCase();

    taskBloc = TaskBloc(
      getAllTasksUseCase: mockGetAllTasksUseCase,
      getMyTasksUseCase: mockGetMyTasksUseCase,
      createTaskUseCase: mockCreateTaskUseCase,
      updateTaskUseCase: mockUpdateTaskUseCase,
      deleteTaskUseCase: mockDeleteTaskUseCase,
      getAllUsersUseCase: mockGetAllUsersUseCase,
      updateMyTaskStatusUseCase: mockUpdateMyTaskStatusUseCase,
    );
  });

  tearDown(() {
    taskBloc.close();
  });

  group('TaskBloc', () {
    test('initial state is TaskInitial', () {
      expect(taskBloc.state, isA<TaskInitial>());
    });

    test('bloc can be created', () {
      expect(taskBloc, isA<TaskBloc>());
    });

    test('bloc has correct use cases', () {
      expect(taskBloc.getAllTasksUseCase, equals(mockGetAllTasksUseCase));
      expect(taskBloc.getMyTasksUseCase, equals(mockGetMyTasksUseCase));
      expect(taskBloc.createTaskUseCase, equals(mockCreateTaskUseCase));
      expect(taskBloc.updateTaskUseCase, equals(mockUpdateTaskUseCase));
      expect(taskBloc.deleteTaskUseCase, equals(mockDeleteTaskUseCase));
      expect(taskBloc.getAllUsersUseCase, equals(mockGetAllUsersUseCase));
      expect(taskBloc.updateMyTaskStatusUseCase, equals(mockUpdateMyTaskStatusUseCase));
    });

    test('bloc can be closed', () {
      expect(() => taskBloc.close(), returnsNormally);
    });
  });
} 
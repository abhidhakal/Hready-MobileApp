import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:hready/features/leaves/presentation/view_model/leave_bloc.dart';
import 'package:hready/features/leaves/domain/repositories/leave_repository.dart';

class MockLeaveRepository extends Mock implements LeaveRepository {}

void main() {
  late LeaveBloc leaveBloc;
  late MockLeaveRepository mockLeaveRepository;

  setUp(() {
    mockLeaveRepository = MockLeaveRepository();
    leaveBloc = LeaveBloc(mockLeaveRepository);
  });

  tearDown(() {
    leaveBloc.close();
  });

  group('LeaveBloc', () {
    test('initial state is LeaveLoading', () {
      expect(leaveBloc.state, isA<LeaveLoading>());
    });

    test('bloc can be created', () {
      expect(leaveBloc, isA<LeaveBloc>());
    });

    test('bloc has correct repository', () {
      expect(leaveBloc.repository, equals(mockLeaveRepository));
    });

    test('bloc can be closed', () {
      expect(() => leaveBloc.close(), returnsNormally);
    });
  });
} 
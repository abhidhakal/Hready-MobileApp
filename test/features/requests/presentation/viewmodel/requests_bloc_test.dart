import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:hready/features/requests/presentation/viewmodel/requests_bloc.dart';
import 'package:hready/features/requests/presentation/viewmodel/requests_state.dart';
import 'package:hready/features/requests/domain/use_cases/get_all_requests_use_case.dart';
import 'package:hready/features/requests/domain/use_cases/approve_request_use_case.dart';
import 'package:hready/features/requests/domain/use_cases/reject_request_use_case.dart';
import 'package:hready/features/requests/domain/use_cases/get_my_requests_use_case.dart';
import 'package:hready/features/requests/domain/use_cases/submit_request_use_case.dart';

class MockGetAllRequestsUseCase extends Mock implements GetAllRequestsUseCase {}
class MockApproveRequestUseCase extends Mock implements ApproveRequestUseCase {}
class MockRejectRequestUseCase extends Mock implements RejectRequestUseCase {}
class MockGetMyRequestsUseCase extends Mock implements GetMyRequestsUseCase {}
class MockSubmitRequestUseCase extends Mock implements SubmitRequestUseCase {}

void main() {
  late RequestsBloc requestsBloc;
  late MockGetAllRequestsUseCase mockGetAllRequestsUseCase;
  late MockApproveRequestUseCase mockApproveRequestUseCase;
  late MockRejectRequestUseCase mockRejectRequestUseCase;
  late MockGetMyRequestsUseCase mockGetMyRequestsUseCase;
  late MockSubmitRequestUseCase mockSubmitRequestUseCase;

  setUp(() {
    mockGetAllRequestsUseCase = MockGetAllRequestsUseCase();
    mockApproveRequestUseCase = MockApproveRequestUseCase();
    mockRejectRequestUseCase = MockRejectRequestUseCase();
    mockGetMyRequestsUseCase = MockGetMyRequestsUseCase();
    mockSubmitRequestUseCase = MockSubmitRequestUseCase();

    requestsBloc = RequestsBloc(
      getAllRequestsUseCase: mockGetAllRequestsUseCase,
      approveRequestUseCase: mockApproveRequestUseCase,
      rejectRequestUseCase: mockRejectRequestUseCase,
      getMyRequestsUseCase: mockGetMyRequestsUseCase,
      submitRequestUseCase: mockSubmitRequestUseCase,
    );
  });

  tearDown(() {
    requestsBloc.close();
  });

  group('RequestsBloc', () {
    test('initial state is RequestsState', () {
      expect(requestsBloc.state, isA<RequestsState>());
    });

    test('bloc can be created', () {
      expect(requestsBloc, isA<RequestsBloc>());
    });

    test('bloc has correct use cases', () {
      expect(requestsBloc.getAllRequestsUseCase, equals(mockGetAllRequestsUseCase));
      expect(requestsBloc.approveRequestUseCase, equals(mockApproveRequestUseCase));
      expect(requestsBloc.rejectRequestUseCase, equals(mockRejectRequestUseCase));
      expect(requestsBloc.getMyRequestsUseCase, equals(mockGetMyRequestsUseCase));
      expect(requestsBloc.submitRequestUseCase, equals(mockSubmitRequestUseCase));
    });

    test('bloc can be closed', () {
      expect(() => requestsBloc.close(), returnsNormally);
    });
  });
} 
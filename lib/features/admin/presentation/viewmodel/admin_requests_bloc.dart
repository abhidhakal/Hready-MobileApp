import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/admin/presentation/viewmodel/admin_requests_event.dart';
import 'package:hready/features/admin/presentation/viewmodel/admin_requests_state.dart';
import 'package:hready/features/requests/domain/use_cases/get_all_requests_use_case.dart';
import 'package:hready/features/requests/domain/use_cases/approve_request_use_case.dart';
import 'package:hready/features/requests/domain/use_cases/reject_request_use_case.dart';
import 'package:hready/app/service_locator/service_locator.dart';

class AdminRequestsBloc extends Bloc<AdminRequestsEvent, AdminRequestsState> {
  final GetAllRequestsUseCase _getAllRequests = getIt<GetAllRequestsUseCase>();
  final ApproveRequestUseCase _approveRequest = getIt<ApproveRequestUseCase>();
  final RejectRequestUseCase _rejectRequest = getIt<RejectRequestUseCase>();

  AdminRequestsBloc() : super(const AdminRequestsState()) {
    on<LoadRequests>(_onLoadRequests);
    on<ApproveRequest>(_onApproveRequest);
    on<RejectRequest>(_onRejectRequest);
    on<ActionCommentChanged>(_onActionCommentChanged);
    on<ActionModeChanged>(_onActionModeChanged);
  }

  Future<void> _onLoadRequests(LoadRequests event, Emitter<AdminRequestsState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final requests = await _getAllRequests();
      emit(state.copyWith(isLoading: false, requests: requests, error: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to fetch requests'));
    }
  }

  Future<void> _onApproveRequest(ApproveRequest event, Emitter<AdminRequestsState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _approveRequest(event.requestId); // Pass comment if API supports
      emit(state.copyWith(isLoading: false));
      add(LoadRequests());
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to approve request'));
    }
  }

  Future<void> _onRejectRequest(RejectRequest event, Emitter<AdminRequestsState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _rejectRequest(event.requestId); // Pass comment if API supports
      emit(state.copyWith(isLoading: false));
      add(LoadRequests());
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to reject request'));
    }
  }

  void _onActionCommentChanged(ActionCommentChanged event, Emitter<AdminRequestsState> emit) {
    final newActionState = Map<String, ActionState>.from(state.actionState);
    final prev = newActionState[event.requestId] ?? const ActionState();
    newActionState[event.requestId] = prev.copyWith(comment: event.comment);
    emit(state.copyWith(actionState: newActionState));
  }

  void _onActionModeChanged(ActionModeChanged event, Emitter<AdminRequestsState> emit) {
    final newActionState = Map<String, ActionState>.from(state.actionState);
    final prev = newActionState[event.requestId] ?? const ActionState();
    newActionState[event.requestId] = prev.copyWith(mode: event.mode, comment: event.mode == null ? '' : prev.comment);
    emit(state.copyWith(actionState: newActionState));
  }
} 
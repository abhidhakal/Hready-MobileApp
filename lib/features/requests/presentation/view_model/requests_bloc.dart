import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/requests/presentation/view_model/requests_event.dart';
import 'package:hready/features/requests/presentation/view_model/requests_state.dart';
import 'package:hready/features/requests/domain/use_cases/get_all_requests_use_case.dart';
import 'package:hready/features/requests/domain/use_cases/approve_request_use_case.dart';
import 'package:hready/features/requests/domain/use_cases/reject_request_use_case.dart';
import 'package:hready/features/requests/domain/use_cases/get_my_requests_use_case.dart';
import 'package:hready/features/requests/domain/use_cases/submit_request_use_case.dart';
import 'package:hready/app/service_locator/service_locator.dart';

class RequestsBloc extends Bloc<RequestsEvent, RequestsState> {
  final GetAllRequestsUseCase getAllRequestsUseCase;
  final ApproveRequestUseCase approveRequestUseCase;
  final RejectRequestUseCase rejectRequestUseCase;
  final GetMyRequestsUseCase getMyRequestsUseCase;
  final SubmitRequestUseCase submitRequestUseCase;

  RequestsBloc({
    required this.getAllRequestsUseCase,
    required this.approveRequestUseCase,
    required this.rejectRequestUseCase,
    GetMyRequestsUseCase? getMyRequestsUseCase,
    SubmitRequestUseCase? submitRequestUseCase,
  })  : getMyRequestsUseCase = getMyRequestsUseCase ?? getIt<GetMyRequestsUseCase>(),
        submitRequestUseCase = submitRequestUseCase ?? getIt<SubmitRequestUseCase>(),
        super(const RequestsState()) {
    on<LoadRequests>(_onLoadRequests);
    on<ApproveRequest>(_onApproveRequest);
    on<RejectRequest>(_onRejectRequest);
    on<ActionCommentChanged>(_onActionCommentChanged);
    on<ActionModeChanged>(_onActionModeChanged);
    // Employee events
    on<LoadMyRequests>(_onLoadMyRequests);
    on<SubmitRequest>(_onSubmitRequest);
    on<EmployeeFormChanged>(_onEmployeeFormChanged);
  }

  Future<void> _onLoadRequests(LoadRequests event, Emitter<RequestsState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final requests = await getAllRequestsUseCase();
      emit(state.copyWith(isLoading: false, requests: requests, error: null));
    } catch (e) {
      print('Fetch all requests error: $e');
      emit(state.copyWith(isLoading: false, error: 'Failed to fetch requests'));
    }
  }

  Future<void> _onApproveRequest(ApproveRequest event, Emitter<RequestsState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await approveRequestUseCase(event.requestId, comment: event.comment);
      emit(state.copyWith(isLoading: false));
      // Clear the action state for this request
      final newActionState = Map<String, ActionState>.from(state.actionState);
      newActionState[event.requestId] = const ActionState();
      emit(state.copyWith(actionState: newActionState));
      add(LoadRequests());
    } catch (e) {
      String errorMsg = 'Failed to approve request';
      if (e is Exception) {
        errorMsg = e.toString();
      }
      print('Approve request error: $e');
      emit(state.copyWith(isLoading: false, error: errorMsg));
    }
  }

  Future<void> _onRejectRequest(RejectRequest event, Emitter<RequestsState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await rejectRequestUseCase(event.requestId, comment: event.comment);
      emit(state.copyWith(isLoading: false));
      // Clear the action state for this request
      final newActionState = Map<String, ActionState>.from(state.actionState);
      newActionState[event.requestId] = const ActionState();
      emit(state.copyWith(actionState: newActionState));
      add(LoadRequests());
    } catch (e) {
      String errorMsg = 'Failed to reject request';
      if (e is Exception) {
        errorMsg = e.toString();
      }
      print('Reject request error: $e');
      emit(state.copyWith(isLoading: false, error: errorMsg));
    }
  }

  void _onActionCommentChanged(ActionCommentChanged event, Emitter<RequestsState> emit) {
    final newActionState = Map<String, ActionState>.from(state.actionState);
    final prev = newActionState[event.requestId] ?? const ActionState();
    newActionState[event.requestId] = prev.copyWith(comment: event.comment);
    emit(state.copyWith(actionState: newActionState));
  }

  void _onActionModeChanged(ActionModeChanged event, Emitter<RequestsState> emit) {
    final newActionState = Map<String, ActionState>.from(state.actionState);
    final prev = newActionState[event.requestId] ?? const ActionState();
    newActionState[event.requestId] = prev.copyWith(mode: event.mode, comment: event.mode == null ? '' : prev.comment);
    emit(state.copyWith(actionState: newActionState));
  }

  // Employee events
  Future<void> _onLoadMyRequests(LoadMyRequests event, Emitter<RequestsState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final requests = await getMyRequestsUseCase();
      emit(state.copyWith(isLoading: false, requests: requests, error: null));
    } catch (e) {
      print('Fetch my requests error: $e');
      emit(state.copyWith(isLoading: false, error: 'Failed to fetch requests'));
    }
  }

  Future<void> _onSubmitRequest(SubmitRequest event, Emitter<RequestsState> emit) async {
    emit(state.copyWith(isSubmitting: true, error: null));
    try {
      await submitRequestUseCase(
        title: event.title,
        message: event.message,
        type: event.type,
        attachment: event.attachment,
      );
      emit(state.copyWith(
        isSubmitting: false,
        formTitle: '',
        formMessage: '',
        formType: 'request',
        formAttachment: null,
      ));
      add(LoadMyRequests());
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, error: 'Failed to send request'));
    }
  }

  void _onEmployeeFormChanged(EmployeeFormChanged event, Emitter<RequestsState> emit) {
    switch (event.field) {
      case 'title':
        emit(state.copyWith(formTitle: event.value));
        break;
      case 'message':
        emit(state.copyWith(formMessage: event.value));
        break;
      case 'type':
        emit(state.copyWith(formType: event.value));
        break;
      case 'attachment':
        emit(state.copyWith(formAttachment: event.value));
        break;
    }
  }
} 
import 'package:equatable/equatable.dart';
import 'package:hready/features/requests/domain/entities/request_entity.dart';

class AdminRequestsState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<RequestEntity> requests;
  final Map<String, ActionState> actionState;

  const AdminRequestsState({
    this.isLoading = false,
    this.error,
    this.requests = const [],
    this.actionState = const {},
  });

  AdminRequestsState copyWith({
    bool? isLoading,
    String? error,
    List<RequestEntity>? requests,
    Map<String, ActionState>? actionState,
  }) {
    return AdminRequestsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      requests: requests ?? this.requests,
      actionState: actionState ?? this.actionState,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, requests, actionState];
}

class ActionState extends Equatable {
  final String? mode; // 'approve' | 'reject' | null
  final String comment;
  const ActionState({this.mode, this.comment = ''});

  ActionState copyWith({String? mode, String? comment}) {
    return ActionState(
      mode: mode ?? this.mode,
      comment: comment ?? this.comment,
    );
  }

  @override
  List<Object?> get props => [mode, comment];
} 
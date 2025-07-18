import 'package:equatable/equatable.dart';

abstract class AdminRequestsEvent extends Equatable {
  const AdminRequestsEvent();
  @override
  List<Object?> get props => [];
}

class LoadRequests extends AdminRequestsEvent {}

class ApproveRequest extends AdminRequestsEvent {
  final String requestId;
  final String comment;
  const ApproveRequest(this.requestId, this.comment);
  @override
  List<Object?> get props => [requestId, comment];
}

class RejectRequest extends AdminRequestsEvent {
  final String requestId;
  final String comment;
  const RejectRequest(this.requestId, this.comment);
  @override
  List<Object?> get props => [requestId, comment];
}

class ActionCommentChanged extends AdminRequestsEvent {
  final String requestId;
  final String comment;
  const ActionCommentChanged(this.requestId, this.comment);
  @override
  List<Object?> get props => [requestId, comment];
}

class ActionModeChanged extends AdminRequestsEvent {
  final String requestId;
  final String? mode; // 'approve' | 'reject' | null
  const ActionModeChanged(this.requestId, this.mode);
  @override
  List<Object?> get props => [requestId, mode];
} 
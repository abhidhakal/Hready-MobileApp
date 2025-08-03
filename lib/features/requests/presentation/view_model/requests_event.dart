import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class RequestsEvent extends Equatable {
  const RequestsEvent();
  @override
  List<Object?> get props => [];
}

// Admin events
class LoadRequests extends RequestsEvent {}
class ApproveRequest extends RequestsEvent {
  final String requestId;
  final String comment;
  const ApproveRequest(this.requestId, this.comment);
  @override
  List<Object?> get props => [requestId, comment];
}
class RejectRequest extends RequestsEvent {
  final String requestId;
  final String comment;
  const RejectRequest(this.requestId, this.comment);
  @override
  List<Object?> get props => [requestId, comment];
}
class ActionCommentChanged extends RequestsEvent {
  final String requestId;
  final String comment;
  const ActionCommentChanged(this.requestId, this.comment);
  @override
  List<Object?> get props => [requestId, comment];
}
class ActionModeChanged extends RequestsEvent {
  final String requestId;
  final String? mode;
  const ActionModeChanged(this.requestId, this.mode);
  @override
  List<Object?> get props => [requestId, mode];
}

// Employee events
class LoadMyRequests extends RequestsEvent {}
class SubmitRequest extends RequestsEvent {
  final String title;
  final String message;
  final String type;
  final File? attachment;
  const SubmitRequest({required this.title, required this.message, required this.type, this.attachment});
  @override
  List<Object?> get props => [title, message, type, attachment];
}
class EmployeeFormChanged extends RequestsEvent {
  final String field;
  final dynamic value;
  const EmployeeFormChanged(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
} 
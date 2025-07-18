import 'package:equatable/equatable.dart';
import 'package:hready/features/requests/domain/entities/request_entity.dart';
import 'dart:io';

class RequestsState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<RequestEntity> requests;
  final Map<String, ActionState> actionState;
  // Employee form state
  final String formTitle;
  final String formMessage;
  final String formType;
  final File? formAttachment;
  final bool isSubmitting;

  const RequestsState({
    this.isLoading = false,
    this.error,
    this.requests = const [],
    this.actionState = const {},
    this.formTitle = '',
    this.formMessage = '',
    this.formType = 'request',
    this.formAttachment,
    this.isSubmitting = false,
  });

  RequestsState copyWith({
    bool? isLoading,
    String? error,
    List<RequestEntity>? requests,
    Map<String, ActionState>? actionState,
    String? formTitle,
    String? formMessage,
    String? formType,
    File? formAttachment,
    bool? isSubmitting,
  }) {
    return RequestsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      requests: requests ?? this.requests,
      actionState: actionState ?? this.actionState,
      formTitle: formTitle ?? this.formTitle,
      formMessage: formMessage ?? this.formMessage,
      formType: formType ?? this.formType,
      formAttachment: formAttachment ?? this.formAttachment,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, requests, actionState, formTitle, formMessage, formType, formAttachment, isSubmitting];
}

class ActionState extends Equatable {
  final String? mode;
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
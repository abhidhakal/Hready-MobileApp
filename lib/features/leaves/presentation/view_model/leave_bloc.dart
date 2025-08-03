import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/leave_entity.dart';
import '../../domain/repositories/leave_repository.dart';
import 'package:hready/core/notifications/simple_notification_service.dart';

abstract class LeaveEvent {}
class LoadLeaves extends LeaveEvent {}
class CreateLeave extends LeaveEvent {
  final LeaveEntity leave;
  CreateLeave(this.leave);
}
class ApproveLeave extends LeaveEvent {
  final String id;
  ApproveLeave(this.id);
}
class RejectLeave extends LeaveEvent {
  final String id;
  RejectLeave(this.id);
}
class LoadMyLeaves extends LeaveEvent {}
class CreateMyLeave extends LeaveEvent {
  final LeaveEntity leave;
  CreateMyLeave(this.leave);
}

abstract class LeaveState {}
class LeaveLoading extends LeaveState {}
class LeaveLoaded extends LeaveState {
  final List<LeaveEntity> leaves;
  LeaveLoaded(this.leaves);
}
class LeaveError extends LeaveState {
  final String error;
  LeaveError(this.error);
}

class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
  final LeaveRepository repository;
  LeaveBloc(this.repository) : super(LeaveLoading()) {
    on<LoadLeaves>((event, emit) async {
      emit(LeaveLoading());
      try {
        final leaves = await repository.getAllLeaves();
        emit(LeaveLoaded(leaves));
      } catch (e) {
        emit(LeaveError(e.toString()));
      }
    });
    on<CreateLeave>((event, emit) async {
      emit(LeaveLoading());
      try {
        await repository.createAdminLeave(event.leave);
        await simpleNotificationService.showSuccessNotification('Leave request created successfully!');
        add(LoadLeaves());
      } catch (e) {
        await simpleNotificationService.showErrorNotification('Failed to create leave request: ${e.toString()}');
        emit(LeaveError(e.toString()));
      }
    });
    on<ApproveLeave>((event, emit) async {
      emit(LeaveLoading());
      try {
        await repository.updateLeaveStatus(event.id, 'Approved');
        await simpleNotificationService.showLeaveNotification('approved');
        add(LoadLeaves());
      } catch (e) {
        await simpleNotificationService.showErrorNotification('Failed to approve leave: ${e.toString()}');
        emit(LeaveError(e.toString()));
      }
    });
    on<RejectLeave>((event, emit) async {
      emit(LeaveLoading());
      try {
        await repository.updateLeaveStatus(event.id, 'Rejected');
        await simpleNotificationService.showLeaveNotification('rejected');
        add(LoadLeaves());
      } catch (e) {
        await simpleNotificationService.showErrorNotification('Failed to reject leave: ${e.toString()}');
        emit(LeaveError(e.toString()));
      }
    });
    on<LoadMyLeaves>((event, emit) async {
      emit(LeaveLoading());
      try {
        final leaves = await repository.getMyLeaves();
        emit(LeaveLoaded(leaves));
      } catch (e) {
        emit(LeaveError(e.toString()));
      }
    });
    on<CreateMyLeave>((event, emit) async {
      emit(LeaveLoading());
      try {
        await repository.createLeave(event.leave);
        await simpleNotificationService.showSuccessNotification('Leave request submitted successfully!');
        add(LoadMyLeaves());
      } catch (e) {
        await simpleNotificationService.showErrorNotification('Failed to submit leave request: ${e.toString()}');
        emit(LeaveError(e.toString()));
      }
    });
  }
} 
import '../../domain/entities/leave_entity.dart';
import '../../domain/repositories/leave_repository.dart';
import '../datasources/remote_datasource/leave_remote_data_source.dart';
import '../models/leave_model.dart';

class LeaveRemoteRepository implements LeaveRepository {
  final LeaveRemoteDataSource remoteDataSource;
  LeaveRemoteRepository(this.remoteDataSource);

  @override
  Future<List<LeaveEntity>> getAllLeaves() async {
    final models = await remoteDataSource.getAllLeaves();
    return models.map(_toEntity).toList();
  }

  @override
  Future<LeaveEntity> getLeaveById(String id) async {
    final model = await remoteDataSource.getLeaveById(id);
    return _toEntity(model);
  }

  @override
  Future<LeaveEntity> createLeave(LeaveEntity leave) async {
    final model = LeaveModel(
      id: leave.id,
      requestedBy: leave.requestedBy,
      leaveType: leave.leaveType,
      startDate: leave.startDate,
      endDate: leave.endDate,
      halfDay: leave.halfDay,
      reason: leave.reason,
      attachment: leave.attachment,
      status: leave.status,
      adminComment: leave.adminComment,
      createdAt: leave.createdAt,
    );
    final created = await remoteDataSource.createLeave(model);
    return _toEntity(created);
  }

  @override
  Future<LeaveEntity> updateLeave(String id, LeaveEntity leave) async {
    final model = LeaveModel(
      id: leave.id,
      requestedBy: leave.requestedBy,
      leaveType: leave.leaveType,
      startDate: leave.startDate,
      endDate: leave.endDate,
      halfDay: leave.halfDay,
      reason: leave.reason,
      attachment: leave.attachment,
      status: leave.status,
      adminComment: leave.adminComment,
      createdAt: leave.createdAt,
    );
    final updated = await remoteDataSource.updateLeave(id, model);
    return _toEntity(updated);
  }

  @override
  Future<void> deleteLeave(String id) async {
    await remoteDataSource.deleteLeave(id);
  }

  @override
  Future<List<LeaveEntity>> getMyLeaves() async {
    final models = await remoteDataSource.getMyLeaves();
    return models.map(_toEntity).toList();
  }

  @override
  Future<LeaveEntity> updateLeaveStatus(String id, String status, {String? adminComment}) async {
    final updated = await remoteDataSource.updateLeaveStatus(id, status, adminComment: adminComment);
    return _toEntity(updated);
  }

  @override
  Future<LeaveEntity> createAdminLeave(LeaveEntity leave) async {
    final model = LeaveModel(
      id: leave.id,
      requestedBy: leave.requestedBy,
      leaveType: leave.leaveType,
      startDate: leave.startDate,
      endDate: leave.endDate,
      halfDay: leave.halfDay,
      reason: leave.reason,
      attachment: leave.attachment,
      status: leave.status,
      adminComment: leave.adminComment,
      createdAt: leave.createdAt,
    );
    final created = await remoteDataSource.createAdminLeave(model);
    return _toEntity(created);
  }

  LeaveEntity _toEntity(LeaveModel m) => LeaveEntity(
    id: m.id,
    requestedBy: m.requestedBy,
    leaveType: m.leaveType,
    startDate: m.startDate,
    endDate: m.endDate,
    halfDay: m.halfDay,
    reason: m.reason,
    attachment: m.attachment,
    status: m.status,
    adminComment: m.adminComment,
    createdAt: m.createdAt,
  );
} 
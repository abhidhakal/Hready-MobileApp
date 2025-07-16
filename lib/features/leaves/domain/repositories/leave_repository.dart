import '../entities/leave_entity.dart';

abstract class LeaveRepository {
  Future<List<LeaveEntity>> getAllLeaves();
  Future<LeaveEntity> getLeaveById(String id);
  Future<LeaveEntity> createLeave(LeaveEntity leave);
  Future<LeaveEntity> updateLeave(String id, LeaveEntity leave);
  Future<void> deleteLeave(String id);
  Future<List<LeaveEntity>> getMyLeaves();
  Future<LeaveEntity> updateLeaveStatus(String id, String status, {String? adminComment});
  Future<LeaveEntity> createAdminLeave(LeaveEntity leave);
} 
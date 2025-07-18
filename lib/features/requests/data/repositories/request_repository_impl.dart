import '../../domain/entities/request_entity.dart';
import '../../domain/repositories/request_repository.dart';
import '../datasources/remote_datasource/request_remote_data_source.dart';
import '../models/request_model.dart';

class RequestRepositoryImpl implements RequestRepository {
  final RequestRemoteDataSource remoteDataSource;

  RequestRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<RequestEntity>> getAllRequests() async {
    final models = await remoteDataSource.getAllRequests();
    return models.map((model) => RequestEntity(
      id: model.id,
      title: model.title,
      type: model.type,
      status: model.status,
      message: model.message,
      createdBy: model.createdBy != null
          ? CreatedByEntity(
              name: model.createdBy!.name,
              email: model.createdBy!.email,
            )
          : null,
      createdAt: model.createdAt,
      attachment: model.attachment,
      adminComment: model.adminComment,
    )).toList();
  }

  @override
  Future<void> approveRequest(String requestId) async {
    await remoteDataSource.approveRequest(requestId);
  }

  @override
  Future<void> rejectRequest(String requestId) async {
    await remoteDataSource.rejectRequest(requestId);
  }
} 
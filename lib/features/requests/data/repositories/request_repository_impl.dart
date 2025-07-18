import 'dart:io';
import 'package:dio/dio.dart';
import '../../domain/entities/request_entity.dart';
import '../../domain/repositories/request_repository.dart';
import '../datasources/remote_datasource/request_remote_data_source.dart';

class RequestRepositoryImpl implements RequestRepository {
  final RequestRemoteDataSource remoteDataSource;

  RequestRepositoryImpl(Dio dio)
      : remoteDataSource = RequestRemoteDataSourceImpl(dio);

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
  Future<void> approveRequest(String requestId, {String? comment}) async {
    await remoteDataSource.approveRequest(requestId, comment: comment);
  }

  @override
  Future<void> rejectRequest(String requestId, {String? comment}) async {
    await remoteDataSource.rejectRequest(requestId, comment: comment);
  }

  @override
  Future<List<RequestEntity>> getMyRequests() async {
    final models = await remoteDataSource.getMyRequests();
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
  Future<void> submitRequest({required String title, required String message, required String type, File? attachment}) async {
    await remoteDataSource.submitRequest(title: title, message: message, type: type, attachment: attachment);
  }
} 
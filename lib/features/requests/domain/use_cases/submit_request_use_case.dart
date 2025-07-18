import '../repositories/request_repository.dart';
import 'dart:io';

class SubmitRequestUseCase {
  final RequestRepository repository;
  SubmitRequestUseCase(this.repository);

  Future<void> call({required String title, required String message, required String type, File? attachment}) async {
    await repository.submitRequest(title: title, message: message, type: type, attachment: attachment);
  }
} 
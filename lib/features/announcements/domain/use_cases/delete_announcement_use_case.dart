import '../repositories/announcement_repository.dart';

class DeleteAnnouncementUseCase {
  final AnnouncementRepository repository;
  DeleteAnnouncementUseCase(this.repository);

  Future<void> call(String id) => repository.deleteAnnouncement(id);
} 
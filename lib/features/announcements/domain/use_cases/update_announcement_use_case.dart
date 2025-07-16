import '../entities/announcement_entity.dart';
import '../repositories/announcement_repository.dart';

class UpdateAnnouncementUseCase {
  final AnnouncementRepository repository;
  UpdateAnnouncementUseCase(this.repository);

  Future<AnnouncementEntity> call(String id, AnnouncementEntity announcement) =>
      repository.updateAnnouncement(id, announcement);
} 
import '../entities/announcement_entity.dart';
import '../repositories/announcement_repository.dart';

class CreateAnnouncementUseCase {
  final AnnouncementRepository repository;
  CreateAnnouncementUseCase(this.repository);

  Future<AnnouncementEntity> call(AnnouncementEntity announcement) =>
      repository.createAnnouncement(announcement);
} 
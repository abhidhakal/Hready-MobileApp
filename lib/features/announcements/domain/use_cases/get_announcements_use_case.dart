import '../entities/announcement_entity.dart';
import '../repositories/announcement_repository.dart';

class GetAnnouncementsUseCase {
  final AnnouncementRepository repository;
  GetAnnouncementsUseCase(this.repository);

  Future<List<AnnouncementEntity>> call() => repository.getAllAnnouncements();
} 
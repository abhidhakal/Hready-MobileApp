import '../entities/announcement_entity.dart';

abstract class AnnouncementRepository {
  Future<List<AnnouncementEntity>> getAllAnnouncements();
  Future<AnnouncementEntity> createAnnouncement(AnnouncementEntity announcement);
  Future<AnnouncementEntity> updateAnnouncement(String id, AnnouncementEntity announcement);
  Future<void> deleteAnnouncement(String id);
} 
import '../../domain/entities/announcement_entity.dart';
import '../../domain/repositories/announcement_repository.dart';
import '../datasources/remote_datasource/announcement_remote_data_source.dart';
import '../models/announcement_model.dart';

class AnnouncementRemoteRepository implements AnnouncementRepository {
  final AnnouncementRemoteDataSource remoteDataSource;
  AnnouncementRemoteRepository(this.remoteDataSource);

  @override
  Future<List<AnnouncementEntity>> getAllAnnouncements() async {
    final models = await remoteDataSource.getAllAnnouncements();
    return models.map((m) => AnnouncementEntity(
      id: m.id,
      title: m.title,
      message: m.message,
      audience: m.audience,
      postedBy: m.postedBy,
      createdAt: m.createdAt,
    )).toList();
  }

  @override
  Future<AnnouncementEntity> createAnnouncement(AnnouncementEntity announcement) async {
    final model = AnnouncementModel(
      id: announcement.id,
      title: announcement.title,
      message: announcement.message,
      audience: announcement.audience,
      postedBy: announcement.postedBy,
      createdAt: announcement.createdAt,
    );
    final created = await remoteDataSource.createAnnouncement(model);
    return AnnouncementEntity(
      id: created.id,
      title: created.title,
      message: created.message,
      audience: created.audience,
      postedBy: created.postedBy,
      createdAt: created.createdAt,
    );
  }

  @override
  Future<AnnouncementEntity> updateAnnouncement(String id, AnnouncementEntity announcement) async {
    final model = AnnouncementModel(
      id: announcement.id,
      title: announcement.title,
      message: announcement.message,
      audience: announcement.audience,
      postedBy: announcement.postedBy,
      createdAt: announcement.createdAt,
    );
    final updated = await remoteDataSource.updateAnnouncement(id, model);
    return AnnouncementEntity(
      id: updated.id,
      title: updated.title,
      message: updated.message,
      audience: updated.audience,
      postedBy: updated.postedBy,
      createdAt: updated.createdAt,
    );
  }

  @override
  Future<void> deleteAnnouncement(String id) async {
    await remoteDataSource.deleteAnnouncement(id);
  }
} 
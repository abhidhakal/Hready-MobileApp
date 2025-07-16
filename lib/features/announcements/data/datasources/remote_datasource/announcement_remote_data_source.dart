import '../../models/announcement_model.dart';
import 'package:dio/dio.dart';

class AnnouncementRemoteDataSource {
  final Dio dio;
  AnnouncementRemoteDataSource(this.dio);

  Future<List<AnnouncementModel>> getAllAnnouncements() async {
    final response = await dio.get('/announcements');
    return (response.data as List)
        .map((json) => AnnouncementModel.fromJson(json))
        .toList();
  }

  Future<AnnouncementModel> createAnnouncement(AnnouncementModel announcement) async {
    final response = await dio.post('/announcements', data: announcement.toJson());
    return AnnouncementModel.fromJson(response.data);
  }

  Future<AnnouncementModel> updateAnnouncement(String id, AnnouncementModel announcement) async {
    final response = await dio.put('/announcements/ $id', data: announcement.toJson());
    return AnnouncementModel.fromJson(response.data);
  }

  Future<void> deleteAnnouncement(String id) async {
    await dio.delete('/announcements/ $id');
  }
} 
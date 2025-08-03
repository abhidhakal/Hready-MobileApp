import 'package:flutter/material.dart';
import '../../domain/entities/announcement_entity.dart';
import '../../domain/use_cases/get_announcements_use_case.dart';
import '../../domain/use_cases/create_announcement_use_case.dart';
import '../../domain/use_cases/update_announcement_use_case.dart';
import '../../domain/use_cases/delete_announcement_use_case.dart';
import 'announcement_state.dart';
import 'package:hready/core/notifications/simple_notification_service.dart';

class AnnouncementViewModel extends ChangeNotifier {
  final GetAnnouncementsUseCase getAnnouncementsUseCase;
  final CreateAnnouncementUseCase createAnnouncementUseCase;
  final UpdateAnnouncementUseCase updateAnnouncementUseCase;
  final DeleteAnnouncementUseCase deleteAnnouncementUseCase;

  AnnouncementState _state = AnnouncementState();
  AnnouncementState get state => _state;

  AnnouncementViewModel({
    required this.getAnnouncementsUseCase,
    required this.createAnnouncementUseCase,
    required this.updateAnnouncementUseCase,
    required this.deleteAnnouncementUseCase,
  });

  Future<void> loadAnnouncements() async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();
    try {
      final announcements = await getAnnouncementsUseCase();
      _state = _state.copyWith(isLoading: false, announcements: announcements, error: null);
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
    }
    notifyListeners();
  }

  Future<void> addAnnouncement(AnnouncementEntity announcement) async {
    try {
      await createAnnouncementUseCase(announcement);
      await simpleNotificationService.showAnnouncementNotification(announcement.title ?? 'New Announcement');
      await loadAnnouncements();
    } catch (e) {
      await simpleNotificationService.showErrorNotification('Failed to create announcement: ${e.toString()}');
      _state = _state.copyWith(error: e.toString());
      notifyListeners();
    }
  }

  Future<void> updateAnnouncement(String id, AnnouncementEntity announcement) async {
    try {
      await updateAnnouncementUseCase(id, announcement);
      await simpleNotificationService.showSuccessNotification('Announcement updated successfully!');
      await loadAnnouncements();
    } catch (e) {
      await simpleNotificationService.showErrorNotification('Failed to update announcement: ${e.toString()}');
      _state = _state.copyWith(error: e.toString());
      notifyListeners();
    }
  }

  Future<void> deleteAnnouncement(String id) async {
    try {
      await deleteAnnouncementUseCase(id);
      await simpleNotificationService.showSuccessNotification('Announcement deleted successfully!');
      await loadAnnouncements();
    } catch (e) {
      await simpleNotificationService.showErrorNotification('Failed to delete announcement: ${e.toString()}');
      _state = _state.copyWith(error: e.toString());
      notifyListeners();
    }
  }
} 
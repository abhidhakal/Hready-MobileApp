import '../../domain/entities/announcement_entity.dart';

class AnnouncementState {
  final bool isLoading;
  final List<AnnouncementEntity> announcements;
  final String? error;

  AnnouncementState({
    this.isLoading = false,
    this.announcements = const [],
    this.error,
  });

  AnnouncementState copyWith({
    bool? isLoading,
    List<AnnouncementEntity>? announcements,
    String? error,
  }) {
    return AnnouncementState(
      isLoading: isLoading ?? this.isLoading,
      announcements: announcements ?? this.announcements,
      error: error,
    );
  }
} 
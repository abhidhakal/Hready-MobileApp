import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hready/features/announcements/domain/use_cases/get_announcements_use_case.dart';
import 'package:hready/features/announcements/domain/entities/announcement_entity.dart';

import '../../../../mocks/repository.mock.dart';

void main() {
  late GetAnnouncementsUseCase getAnnouncementsUseCase;
  late MockAnnouncementRepository mockAnnouncementRepository;

  setUp(() {
    mockAnnouncementRepository = MockAnnouncementRepository();
    getAnnouncementsUseCase = GetAnnouncementsUseCase(mockAnnouncementRepository);
  });

  final tAnnouncements = [
    AnnouncementEntity(
      id: '1',
      title: 'Company Meeting',
      message: 'All employees meeting on Friday',
      postedBy: 'admin',
      createdAt: DateTime.now(),
    ),
    AnnouncementEntity(
      id: '2',
      title: 'Holiday Notice',
      message: 'Office will be closed on Monday',
      postedBy: 'admin',
      createdAt: DateTime.now(),
    ),
  ];

  test('returns List<AnnouncementEntity> when getting announcements succeeds', () async {
    // Arrange
    when(() => mockAnnouncementRepository.getAllAnnouncements())
        .thenAnswer((_) async => tAnnouncements);

    // Act
    final result = await getAnnouncementsUseCase();

    // Assert
    expect(result, tAnnouncements);
    expect(result.length, 2);
    verify(() => mockAnnouncementRepository.getAllAnnouncements()).called(1);
  });

  test('returns empty list when no announcements found', () async {
    // Arrange
    when(() => mockAnnouncementRepository.getAllAnnouncements())
        .thenAnswer((_) async => <AnnouncementEntity>[]);

    // Act
    final result = await getAnnouncementsUseCase();

    // Assert
    expect(result, isEmpty);
    verify(() => mockAnnouncementRepository.getAllAnnouncements()).called(1);
  });

  test('throws Exception when getting announcements fails', () async {
    // Arrange
    when(() => mockAnnouncementRepository.getAllAnnouncements())
        .thenThrow(Exception('Failed to get announcements'));

    // Act & Assert
    expect(
      () => getAnnouncementsUseCase(),
      throwsA(isA<Exception>()),
    );
    verify(() => mockAnnouncementRepository.getAllAnnouncements()).called(1);
  });
} 
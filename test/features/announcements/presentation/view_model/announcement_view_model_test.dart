import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hready/features/announcements/presentation/view_model/announcement_view_model.dart';
import 'package:hready/features/announcements/domain/use_cases/get_announcements_use_case.dart';
import 'package:hready/features/announcements/domain/use_cases/create_announcement_use_case.dart';
import 'package:hready/features/announcements/domain/use_cases/update_announcement_use_case.dart';
import 'package:hready/features/announcements/domain/use_cases/delete_announcement_use_case.dart';

class MockGetAnnouncementsUseCase extends Mock implements GetAnnouncementsUseCase {}
class MockCreateAnnouncementUseCase extends Mock implements CreateAnnouncementUseCase {}
class MockUpdateAnnouncementUseCase extends Mock implements UpdateAnnouncementUseCase {}
class MockDeleteAnnouncementUseCase extends Mock implements DeleteAnnouncementUseCase {}

void main() {
  late AnnouncementViewModel announcementViewModel;
  late MockGetAnnouncementsUseCase mockGetAnnouncementsUseCase;
  late MockCreateAnnouncementUseCase mockCreateAnnouncementUseCase;
  late MockUpdateAnnouncementUseCase mockUpdateAnnouncementUseCase;
  late MockDeleteAnnouncementUseCase mockDeleteAnnouncementUseCase;

  setUp(() {
    mockGetAnnouncementsUseCase = MockGetAnnouncementsUseCase();
    mockCreateAnnouncementUseCase = MockCreateAnnouncementUseCase();
    mockUpdateAnnouncementUseCase = MockUpdateAnnouncementUseCase();
    mockDeleteAnnouncementUseCase = MockDeleteAnnouncementUseCase();

    announcementViewModel = AnnouncementViewModel(
      getAnnouncementsUseCase: mockGetAnnouncementsUseCase,
      createAnnouncementUseCase: mockCreateAnnouncementUseCase,
      updateAnnouncementUseCase: mockUpdateAnnouncementUseCase,
      deleteAnnouncementUseCase: mockDeleteAnnouncementUseCase,
    );
  });

  group('AnnouncementViewModel', () {
    test('initial state has empty announcements list', () {
      expect(announcementViewModel.state.announcements, isEmpty);
    });

    test('initial state has isLoading false', () {
      expect(announcementViewModel.state.isLoading, false);
    });

    test('initial state has error null', () {
      expect(announcementViewModel.state.error, null);
    });

    test('view model can be created', () {
      expect(announcementViewModel, isA<AnnouncementViewModel>());
    });

    test('view model has correct use cases', () {
      expect(announcementViewModel.getAnnouncementsUseCase, equals(mockGetAnnouncementsUseCase));
      expect(announcementViewModel.createAnnouncementUseCase, equals(mockCreateAnnouncementUseCase));
      expect(announcementViewModel.updateAnnouncementUseCase, equals(mockUpdateAnnouncementUseCase));
      expect(announcementViewModel.deleteAnnouncementUseCase, equals(mockDeleteAnnouncementUseCase));
    });
  });
} 
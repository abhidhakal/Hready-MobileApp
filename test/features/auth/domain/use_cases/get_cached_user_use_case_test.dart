import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hready/features/auth/domain/use_cases/get_cached_user_use_case.dart';
import 'package:hready/features/auth/domain/entities/user_entity.dart';

import '../../../../helpers/token.mock.dart';
import '../../../../mocks/repository.mock.dart';

void main() {
  late GetCachedUserUseCase getCachedUserUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    getCachedUserUseCase = GetCachedUserUseCase(mockAuthRepository);
  });

  final tUser = UserEntity(
    userId: '1',
    name: 'Test User',
    email: 'test@example.com',
    role: 'admin',
    token: dummyToken,
  );

  test('returns UserEntity when cached user exists', () async {
    // Arrange
    when(() => mockAuthRepository.getCachedUser())
        .thenAnswer((_) async => tUser);

    // Act
    final result = await getCachedUserUseCase();

    // Assert
    expect(result, tUser);
    verify(() => mockAuthRepository.getCachedUser()).called(1);
  });

  test('returns null when no cached user exists', () async {
    // Arrange
    when(() => mockAuthRepository.getCachedUser())
        .thenAnswer((_) async => null);

    // Act
    final result = await getCachedUserUseCase();

    // Assert
    expect(result, isNull);
    verify(() => mockAuthRepository.getCachedUser()).called(1);
  });

  test('throws Exception when getting cached user fails', () async {
    // Arrange
    when(() => mockAuthRepository.getCachedUser())
        .thenThrow(Exception('Failed to get cached user'));

    // Act & Assert
    expect(
      () => getCachedUserUseCase(),
      throwsA(isA<Exception>()),
    );
    verify(() => mockAuthRepository.getCachedUser()).called(1);
  });
} 
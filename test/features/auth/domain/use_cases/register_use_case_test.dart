import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hready/features/auth/domain/use_cases/register_use_case.dart';
import 'package:hready/features/auth/domain/entities/user_entity.dart';

import '../../../../helpers/token.mock.dart';
import '../../../../mocks/repository.mock.dart';

void main() {
  late RegisterUseCase registerUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    registerUseCase = RegisterUseCase(mockAuthRepository);
  });

  const tPayload = {
    'name': 'Test User',
    'email': 'test@example.com',
    'password': 'password123',
    'role': 'employee',
  };

  final tUser = UserEntity(
    userId: '1',
    name: 'Test User',
    email: 'test@example.com',
    role: 'employee',
    token: dummyToken,
  );

  test('returns UserEntity when registration succeeds', () async {
    // Arrange
    when(() => mockAuthRepository.register(tPayload))
        .thenAnswer((_) async => tUser);

    // Act
    final result = await registerUseCase(tPayload);

    // Assert
    expect(result, tUser);
    verify(() => mockAuthRepository.register(tPayload)).called(1);
  });

  test('throws Exception when registration fails', () async {
    // Arrange
    when(() => mockAuthRepository.register(tPayload))
        .thenThrow(Exception('Registration failed'));

    // Act & Assert
    expect(
      () => registerUseCase(tPayload),
      throwsA(isA<Exception>()),
    );
    verify(() => mockAuthRepository.register(tPayload)).called(1);
  });
} 
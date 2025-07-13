import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hready/features/auth/domain/use_cases/login_use_case.dart';
import 'package:hready/features/auth/domain/repositories/auth_repository.dart';
import 'package:hready/features/auth/domain/entities/user_entity.dart';

import '../../../../helpers/token.mock.dart';
import '../../../../mocks/repository.mock.dart';

void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';

  final tUser = UserEntity(
    userId: '1',
    name: 'Test User',
    email: tEmail,
    role: 'admin',
    token: dummyToken,
  );

  test('returns UserEntity when login succeeds', () async {
    // Arrange
    when(() => mockAuthRepository.login(tEmail, tPassword))
        .thenAnswer((_) async => tUser);

    // Act
    final result = await loginUseCase(tEmail, tPassword);

    // Assert
    expect(result, tUser);
    verify(() => mockAuthRepository.login(tEmail, tPassword)).called(1);
  });

  test('throws Exception when login fails', () async {
    // Arrange
    when(() => mockAuthRepository.login(tEmail, tPassword))
        .thenThrow(Exception('Invalid credentials'));

    // Act & Assert
    expect(
      () => loginUseCase(tEmail, tPassword),
      throwsA(isA<Exception>()),
    );
    verify(() => mockAuthRepository.login(tEmail, tPassword)).called(1);
  });
}

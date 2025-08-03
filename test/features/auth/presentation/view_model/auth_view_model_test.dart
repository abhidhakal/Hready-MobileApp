import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hready/features/auth/domain/use_cases/login_use_case.dart';
import 'package:hready/features/auth/domain/use_cases/register_use_case.dart';
import 'package:hready/features/auth/domain/use_cases/get_cached_user_use_case.dart';
import 'package:hready/features/auth/domain/entities/user_entity.dart';
import 'package:hready/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:hready/features/auth/presentation/view_model/auth_event.dart';
import 'package:hready/features/auth/presentation/view_model/auth_state.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockGetCachedUserUseCase extends Mock implements GetCachedUserUseCase {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockGetCachedUserUseCase mockGetCachedUserUseCase;

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  final tUser = UserEntity(
    userId: '1',
    name: 'Test User',
    email: tEmail,
    role: 'admin',
    token: 'dummy-token',
  );

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockGetCachedUserUseCase = MockGetCachedUserUseCase();
  });

  blocTest<AuthViewModel, AuthState>(
    'emits [AuthLoading, AuthSuccess] when login succeeds',
    build: () {
      when(() => mockLoginUseCase(tEmail, tPassword))
          .thenAnswer((_) async => tUser);
      return AuthViewModel(
        loginUseCase: mockLoginUseCase,
        registerUseCase: mockRegisterUseCase,
        getCachedUserUseCase: mockGetCachedUserUseCase,
      );
    },
    act: (bloc) => bloc.add(const LoginRequested(tEmail, tPassword)),
    expect: () => [
      AuthLoading(),
      AuthSuccess(tUser),
    ],
  );
}

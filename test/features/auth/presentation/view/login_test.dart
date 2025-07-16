import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:your_app/features/auth/presentation/view/login.dart';
import 'package:your_app/features/auth/presentation/viewmodel/auth_view_model.dart';
import 'package:your_app/features/auth/presentation/viewmodel/auth_state.dart';

import '../../../../mocks/mock_auth_bloc.dart';

void main() {
  late MockAuthViewModel mockAuthViewModel;

  setUp(() {
    mockAuthViewModel = MockAuthViewModel();
  });

  testWidgets('LoginPage shows welcome text and input fields', (WidgetTester tester) async {
    // Arrange
    when(() => mockAuthViewModel.state).thenReturn(AuthInitial());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthViewModel>.value(
          value: mockAuthViewModel,
          child: const LoginPage(),
        ),
      ),
    );

    // Verify welcome text
    expect(find.text("Welcome to HReady!"), findsOneWidget);

    // Verify email field
    expect(find.byType(TextFormField), findsNWidgets(2));

    // Verify LOGIN button
    expect(find.text('LOGIN'), findsOneWidget);

    // Verify Register link
    expect(find.textContaining("Don't have an account"), findsOneWidget);
  });
}

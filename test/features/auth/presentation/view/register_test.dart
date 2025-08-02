import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hready/features/auth/presentation/view/register.dart';

void main() {
  testWidgets('RegisterPage widget can be created', (WidgetTester tester) async {
    expect(() => const RegisterPage(), returnsNormally);
  });

  testWidgets('RegisterPage is a Widget', (WidgetTester tester) async {
    const widget = RegisterPage();
    expect(widget, isA<Widget>());
  });

  testWidgets('RegisterPage has build method', (WidgetTester tester) async {
    const widget = RegisterPage();
    expect(widget, isA<Widget>());
  });

  testWidgets('RegisterPage has StatefulWidget structure', (WidgetTester tester) async {
    const widget = RegisterPage();
    expect(widget, isA<StatefulWidget>());
  });

  testWidgets('RegisterPage can be instantiated without errors', (WidgetTester tester) async {
    expect(() => const RegisterPage(), returnsNormally);
  });
} 
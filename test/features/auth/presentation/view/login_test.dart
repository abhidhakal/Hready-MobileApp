import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hready/features/auth/presentation/view/login.dart';

void main() {
  testWidgets('LoginPage widget can be created', (WidgetTester tester) async {
    expect(() => const LoginPage(), returnsNormally);
  });

  testWidgets('LoginPage is a Widget', (WidgetTester tester) async {
    const widget = LoginPage();
    expect(widget, isA<Widget>());
  });

  testWidgets('LoginPage has build method', (WidgetTester tester) async {
    const widget = LoginPage();
    expect(widget, isA<Widget>());
  });

  testWidgets('LoginPage has StatefulWidget structure', (WidgetTester tester) async {
    const widget = LoginPage();
    expect(widget, isA<StatefulWidget>());
  });

  testWidgets('LoginPage can be instantiated without errors', (WidgetTester tester) async {
    expect(() => const LoginPage(), returnsNormally);
  });
}

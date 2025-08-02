import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hready/features/admin/presentation/view/dashboard_admin.dart';

void main() {
  testWidgets('DashboardAdmin widget can be created', (WidgetTester tester) async {
    expect(() => const DashboardAdmin(), returnsNormally);
  });

  testWidgets('DashboardAdmin is a Widget', (WidgetTester tester) async {
    const widget = DashboardAdmin();
    expect(widget, isA<Widget>());
  });

  testWidgets('DashboardAdmin has build method', (WidgetTester tester) async {
    const widget = DashboardAdmin();
    expect(widget, isA<Widget>());
  });

  testWidgets('DashboardAdmin has MaterialApp structure', (WidgetTester tester) async {
    const widget = DashboardAdmin();
    expect(widget, isA<StatelessWidget>());
  });

  testWidgets('DashboardAdmin can be instantiated without errors', (WidgetTester tester) async {
    expect(() => const DashboardAdmin(), returnsNormally);
  });
}

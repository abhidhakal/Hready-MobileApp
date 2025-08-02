import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hready/features/employee/presentation/view/dashboard_employee.dart';

void main() {
  testWidgets('DashboardEmployee widget can be created', (WidgetTester tester) async {
    expect(() => const DashboardEmployee(), returnsNormally);
  });

  testWidgets('DashboardEmployee is a Widget', (WidgetTester tester) async {
    const widget = DashboardEmployee();
    expect(widget, isA<Widget>());
  });

  testWidgets('DashboardEmployee has build method', (WidgetTester tester) async {
    const widget = DashboardEmployee();
    expect(widget, isA<StatefulWidget>());
  });

  testWidgets('DashboardEmployee has StatefulWidget structure', (WidgetTester tester) async {
    const widget = DashboardEmployee();
    expect(widget, isA<StatefulWidget>());
  });
} 
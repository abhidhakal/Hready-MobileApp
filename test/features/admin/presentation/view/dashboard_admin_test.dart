import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hready/features/admin/presentation/view/dashboard_admin.dart';

void main() {
  testWidgets('DashboardAdmin shows Admin Panel drawer header and default Hello, Admin page',
      (WidgetTester tester) async {
    // Build widget
    await tester.pumpWidget(
      const MaterialApp(
        home: DashboardAdmin(),
      ),
    );

    // Allow animations and bloc to settle
    await tester.pumpAndSettle();

    // Verify the Drawer header text
    expect(find.text('Admin Panel'), findsOneWidget);

    // Verify the default page contains Hello, Admin
    expect(find.text('Hello, Admin'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hready/features/admin/presentation/view/admin_home.dart';

void main() {
  testWidgets('AdminHome shows Hello, Admin text', (WidgetTester tester) async {
    // Build widget
    await tester.pumpWidget(
      const MaterialApp(
        home: AdminHome(),
      ),
    );

    // Verify the text
    expect(find.text('Hello, Admin'), findsOneWidget);
  });
}

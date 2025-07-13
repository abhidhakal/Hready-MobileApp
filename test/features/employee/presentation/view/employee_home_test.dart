import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hready/features/employee/presentation/view/employee_home.dart';

void main() {
  testWidgets('EmployeeHome shows Logout button', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: EmployeeHome(),
      ),
    );

    // Verify the Logout button is present
    expect(find.text('Logout'), findsOneWidget);
  });
}

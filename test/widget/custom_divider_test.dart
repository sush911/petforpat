import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../lib/features/auth/presentation/widgets/custom_divider.dart';

void main() {
  testWidgets('CustomDivider renders correctly with text', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomDivider(text: 'or'),
        ),
      ),
    );

    // Verify if the text is displayed
    expect(find.text('or'), findsOneWidget);

    // Verify if the Divider widgets are present
    expect(find.byType(Divider), findsNWidgets(2)); // Two dividers (one on each side)
  });
}

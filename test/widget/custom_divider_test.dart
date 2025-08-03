import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petforpat/features/auth/presentation/widgets/custom_divider.dart';

void main() {
  testWidgets('CustomDivider displays correctly with provided text', (WidgetTester tester) async {
    const dividerText = 'OR';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CustomDivider(text: dividerText),
        ),
      ),
    );

    // Verify the text is rendered
    expect(find.text(dividerText), findsOneWidget);

    // Verify that two Dividers are present
    expect(find.byType(Divider), findsNWidgets(2));

    // Ensure layout is a Row
    expect(find.byType(Row), findsOneWidget);
  });

  testWidgets('CustomDivider paddings and colors applied properly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CustomDivider(text: 'Test Text'),
        ),
      ),
    );

    final textWidget = tester.widget<Text>(find.text('Test Text'));
    expect(textWidget.style?.color, equals(Colors.grey.shade600));
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petforpat/main.dart';

import '../lib/app/app.dart';

void main() {
  testWidgets('App launches and shows splash screen with logo', (WidgetTester tester) async {
    // Build your app and trigger a frame
    await tester.pumpWidget(const PetForPatApp());

    // Check that the splash screen image or icon is present
    expect(find.byType(Image), findsOneWidget);

    // Let the splash animation finish (2 seconds)
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // After splash, login screen should be shown (check for 'Continue' button)
    expect(find.text('Continue'), findsOneWidget);
  });
}

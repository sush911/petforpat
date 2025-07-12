import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../lib/features/auth/presentation/widgets/social_button.dart';

void main() {
  testWidgets('SocialButton renders correctly and calls onPressed', (WidgetTester tester) async {
    // Create a mock function for onPressed
    bool pressed = false;
    void onPressed() {
      pressed = true;
    }

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SocialButton(
            icon: Icon(Icons.facebook),
            text: 'Continue with Facebook',
            onPressed: onPressed,
          ),
        ),
      ),
    );

    // Verify the button text and icon
    expect(find.text('Continue with Facebook'), findsOneWidget);
    expect(find.byIcon(Icons.facebook), findsOneWidget);

    // Verify if button is present
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Tap the button to check if onPressed is called
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // Trigger a frame

    // Check if onPressed changed the pressed state to true
    expect(pressed, true);
  });
}

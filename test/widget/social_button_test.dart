import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petforpat/features/auth/presentation/widgets/social_button.dart';

void main() {
  testWidgets('SocialButton renders correctly and triggers callback', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SocialButton(
            icon: const Icon(Icons.login),
            text: 'Continue with Google',
            onPressed: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    // Verify text is present
    expect(find.text('Continue with Google'), findsOneWidget);

    // Verify icon is present
    expect(find.byIcon(Icons.login), findsOneWidget);

    // Tap the button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify callback is triggered
    expect(tapped, isTrue);
  });

  testWidgets('SocialButton layout matches expected structure', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SocialButton(
            icon: const Icon(Icons.facebook),
            text: 'Login with Facebook',
            onPressed: () {},
          ),
        ),
      ),
    );

    // Ensure button, icon, and text are structured
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Login with Facebook'), findsOneWidget);
    expect(find.byIcon(Icons.facebook), findsOneWidget);
    expect(find.byType(Row), findsOneWidget);
  });
}

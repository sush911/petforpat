import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petforpat/features/splash/presentation/views/splash_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpSplashScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (_) => const SplashScreen(),
          '/login': (_) => const Scaffold(body: Text('Login View')),
          '/dashboard home': (_) => const Scaffold(body: Text('Dashboard View')),
        },
      ),
    );
  }

  testWidgets('Splash screen displays logo, text and progress indicator', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({}); // No token
    await pumpSplashScreen(tester);

    await tester.pump(); // Start animation
    expect(find.byType(FadeTransition), findsOneWidget);
    expect(find.text('PetForPat'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('Navigates to login when no token is found', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({}); // No token
    await pumpSplashScreen(tester);

    // Wait for delay + navigation
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Login View'), findsOneWidget);
  });

  testWidgets('Navigates to dashboard when token is found', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'auth_token': 'valid_token'});
    await pumpSplashScreen(tester);

    // Wait for delay + navigation
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard View'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'views/splash_view.dart';
import 'views/auth/login_view.dart';        // <--- Updated import path
import 'views/dashboard_view.dart';

void main() {
  runApp(const PetForPatApp());
}

class PetForPatApp extends StatelessWidget {
  const PetForPatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetForPat',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginView(),        // <--- stays same
        '/dashboard': (context) => const DashboardView(),
      },
    );
  }
}

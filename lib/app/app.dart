import 'package:flutter/material.dart';
import 'package:petforpat/features/auth/presentation/views/login_view.dart';
import 'package:petforpat/features/auth/presentation/views/signup_view.dart';
import 'package:petforpat/features/auth/presentation/views/profile_view.dart';
import 'package:petforpat/features/splash/presentation/views/splash_view.dart';

class PetForPatApp extends StatelessWidget {
  const PetForPatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet for Pat',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Initial screen when the app starts
      home: const SplashScreen(),

      // Define named routes for navigation
      routes: {
        '/login': (context) => const LoginView(),
        '/signup': (context) => const SignupView(),
        '/profile': (context) => const ProfileView(),
        // Add other routes here as needed
      },

      // Optional: handle undefined routes gracefully
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(), // fallback screen
        );
      },
    );
  }
}

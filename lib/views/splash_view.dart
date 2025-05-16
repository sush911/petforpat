import 'package:flutter/material.dart';
import 'package:petforpat/views/auth/login_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait 2 seconds and navigate to LoginView
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background with an added soft pattern and shadow effect for depth
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFA726), // Orange
              Color(0xFFFFCC80), // Light Orange
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              spreadRadius: 10,
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: Image.asset(
                  'assets/logo/pet.jpg', // Make sure this path is correct
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pet Adoption',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 8,
                      color: Colors.black45,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

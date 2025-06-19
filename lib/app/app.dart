import 'package:flutter/material.dart';
import 'package:petforpat/features/splash/presentation/views/splash_view.dart';

class PetForPatApp extends StatelessWidget {
  const PetForPatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet for Pat',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(), // Start with splash, then route to login/dashboard
    );
  }
}

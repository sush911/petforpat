import 'package:flutter/material.dart';
import 'package:petforpat/views/splash_view.dart';


class PetForPatApp extends StatelessWidget {
  const PetForPatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet for Pat',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(),
    );
  }
}
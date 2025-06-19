// lib/main.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:petforpat/app/app.dart';
import 'package:petforpat/app/service_locator/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive + all DI
  await Hive.initFlutter();
  await setupServiceLocator();

  runApp(const PetForPatApp());
}

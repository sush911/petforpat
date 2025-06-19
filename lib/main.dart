import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:petforpat/app/app.dart';
import 'package:petforpat/app/service_locator/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Open the Hive box named 'profileInstalled' (or your box name)
  await Hive.openBox('profileInstalled');

  // You can open more boxes here if you have them
  // await Hive.openBox<UserModel>('users');

  // Setup your dependency injection
  await setupServiceLocator();

  // Run your app
  runApp(const PetForPatApp());
}

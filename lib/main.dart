import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:petforpat/app/app.dart';
import 'package:petforpat/app/service_locator/service_locator.dart';
import 'package:petforpat/features/auth/data/models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Only initialize Hive here
  await Hive.initFlutter();

  // Do not register the adapter here — already handled in setupServiceLocator
  // await Hive.openBox<UserModel>('users'); // also unnecessary if done in setupServiceLocator

  // Set up dependency injection and register adapters + open box
  await setupServiceLocator();

  runApp(const PetForPatApp());
}

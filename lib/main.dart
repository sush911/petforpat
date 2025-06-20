import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:petforpat/app/app.dart';
import 'package:petforpat/app/service_locator/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Open the Hive box
  await Hive.openBox('profileInstalled');

  // DEBUG PRINT
  final profileBox = Hive.box('profileInstalled');
  print('🔍 Hive: profileInstalled contents:');
  for (var key in profileBox.keys) {
    print('👉 $key: ${profileBox.get(key)}');
  }

  // Setup DI
  await setupServiceLocator();

  runApp(const PetForPatApp());
}

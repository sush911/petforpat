import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:petforpat/app/app.dart';
import 'package:petforpat/app/service_locator/service_locator.dart';
import 'package:petforpat/features/auth/data/models/user_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // TEMPORARY: delete corrupt box (remove this line in production)
  await Hive.deleteBoxFromDisk('profileInstalled');

  // Register UserModel adapter only once here
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(UserModelAdapter());
  }

  await Hive.openBox('profileInstalled');

  final profileBox = Hive.box('profileInstalled');
  print('🔍 Hive: profileInstalled contents:');
  for (var key in profileBox.keys) {
    print('👉 $key: ${profileBox.get(key)}');
  }

  await setupServiceLocator();

  runApp(const PetForPatApp());
}

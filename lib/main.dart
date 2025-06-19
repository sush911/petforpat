import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'app/app.dart';
import 'features/auth/data/models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive & register adapters
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  Hive.registerAdapter(UserModelAdapter()); // Auto-generated adapter

  // Open your box (create if not exists)
  await Hive.openBox<UserModel>('userBox');

  runApp(const PetForPatApp()); // Run your main app
}
